import base64
import re
import sys

def extract_single_asset(log_file, asset_name, output_path):
    """Extract a single asset from logcat, handling FIRST occurrence only"""
    print(f"Extracting {asset_name} from {log_file}...")
    
    with open(log_file, 'r', encoding='utf-8', errors='ignore') as f:
        lines = f.readlines()
    
    start_marker = f'BASE64_START:{asset_name}'
    end_marker = f'BASE64_END:{asset_name}'
    
    in_block = False
    data_lines = []
    
    for line in lines:
        if start_marker in line and not in_block:
            in_block = True
            print(f"  Found start marker at line")
            continue
            
        if end_marker in line and in_block:
            print(f"  Found end marker, processing {len(data_lines)} data lines")
            break
            
        if in_block:
            data_lines.append(line)
    
    if not data_lines:
        print(f"  ERROR: No data found for {asset_name}")
        return False
    
    # Clean and concatenate
    clean_data = ""
    for line in data_lines:
        line_content = line.strip()
        
        # Remove logcat prefixes
        if 'I flutter :' in line_content:
            parts = line_content.split('I flutter :', 1)
            if len(parts) > 1:
                line_content = parts[1]
        elif 'I/flutter' in line_content and '): ' in line_content:
            parts = line_content.split('): ', 1)
            if len(parts) > 1:
                line_content = parts[1]
        
        # Keep only base64 chars
        line_content = re.sub(r'[^A-Za-z0-9+/=]', '', line_content.strip())
        clean_data += line_content
    
    # Decode
    try:
        # Add padding if needed
        missing_padding = len(clean_data) % 4
        if missing_padding:
            clean_data += '=' * (4 - missing_padding)
        
        decoded = base64.b64decode(clean_data)
        
        with open(output_path, 'wb') as f:
            f.write(decoded)
        
        print(f"  ✅ Successfully extracted {asset_name}: {len(decoded)} bytes -> {output_path}")
        return True
        
    except Exception as e:
        print(f"  ❌ Failed to decode {asset_name}: {e}")
        print(f"  Data length: {len(clean_data)}, First 100 chars: {clean_data[:100]}")
        return False

if __name__ == "__main__":
    log_file = "full_log_retry.txt"
    
    # Extract each asset individually, using FIRST occurrence only
    extract_single_asset(log_file, "app_icon.png", "assets/icons/app_icon.png")
    extract_single_asset(log_file, "splash_logo.png", "assets/icons/splash_logo.png")
    extract_single_asset(log_file, "app_icon_foreground.png", "assets/icons/app_icon_foreground.png")
    
    print("\n✨ Extraction complete!")
