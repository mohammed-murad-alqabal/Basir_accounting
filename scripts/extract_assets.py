import base64
import re
import os
import sys

def extract_assets(log_file):
    print(f"Reading from {log_file}...")
    with open(log_file, 'r', encoding='utf-8', errors='ignore') as f:
        content = f.read()

    # Pattern to find blocks
    # BASE64_START:filename
    # ... data ...
    # BASE64_END:filename
    
    # We use a state machine line by line because regex over huge file with mixed log formats is risky
    
    lines = content.splitlines()
    current_file = None
    current_data = []
    
    print(f"Scanning {len(lines)} lines...")
    
    for line in lines:
        if 'BASE64_START:' in line:
            # line might be "I/flutter (PID): BASE64_START:filename"
            # or "I flutter : BASE64_START:filename"
            parts = line.split('BASE64_START:')
            if len(parts) > 1:
                current_file = parts[1].strip()
                current_data = []
                print(f"Found block start for: {current_file}")
                
        elif 'BASE64_END:' in line:
            if current_file:
                parts = line.split('BASE64_END:')
                if len(parts) > 1:
                    file_name = parts[1].strip()
                    if file_name == current_file:
                        # Process
                        full_data_str = " ".join(current_data)
                        
                        # Clean data
                        # We need to process line by line or chunk by chunk
                        clean_data = ""
                        for chunk in current_data:
                            line_content = chunk.strip()
                            
                            # Logcat prefix removal
                            # Heuristics for common formats
                            if 'BASE64_START' in line_content: continue # Should not happen if logic is correct
                            
                            # Format: "... I flutter : data"
                            if 'I flutter :' in line_content:
                                subparts = line_content.split('I flutter :', 1)
                                if len(subparts) > 1:
                                    line_content = subparts[1]
                            # Format: "... I/flutter ( 123): data"
                            elif 'I/flutter' in line_content and '): ' in line_content:
                                subparts = line_content.split('): ')
                                if len(subparts) > 1:
                                    line_content = subparts[1]
                            
                            line_content = line_content.strip()
                            # Remove non-base64 chars
                            line_content = re.sub(r'[^A-Za-z0-9+/=]', '', line_content)
                            clean_data += line_content

                        try:
                            # Pad if necessary
                            missing_padding = len(clean_data) % 4
                            if missing_padding:
                                clean_data += '=' * (4 - missing_padding)
                                
                            decoded = base64.b64decode(clean_data)
                            out_path = f"assets/icons/{current_file}"
                            with open(out_path, 'wb') as out_f:
                                out_f.write(decoded)
                            print(f"✅ Decoded and saved: {out_path} ({len(decoded)} bytes)")
                        except Exception as e:
                            print(f"❌ Failed to decode {current_file}: {e}")
                            # debug: print first 100 chars
                            print(f"Debug data: {clean_data[:100]}...")
                            
                        current_file = None
                        current_data = []
        else:
            if current_file:
                current_data.append(line)

    print("Extraction process complete.")

if __name__ == "__main__":
    target_file = sys.argv[1] if len(sys.argv) > 1 else "full_log_retry.txt"
    extract_assets(target_file)
