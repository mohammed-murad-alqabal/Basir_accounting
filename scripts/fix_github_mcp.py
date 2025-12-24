#!/usr/bin/env python3
"""
سكريبت إصلاح GitHub MCP Server
تم إنشاؤه بواسطة: فريق وكلاء تطوير مشروع بصير
التاريخ: 15 ديسمبر 2025
"""

import json
import os
import subprocess
import sys
from pathlib import Path

def print_status(message, status="info"):
    """طباعة رسالة مع تنسيق ملون"""
    colors = {
        "info": "\033[0;34m",      # أزرق
        "success": "\033[0;32m",   # أخضر
        "warning": "\033[1;33m",   # أصفر
        "error": "\033[0;31m",     # أحمر
        "reset": "\033[0m"         # إعادة تعيين
    }
    
    icons = {
        "info": "ℹ️",
        "success": "✅",
        "warning": "⚠️",
        "error": "❌"
    }
    
    print(f"{colors[status]}{icons[status]} {message}{colors['reset']}")

def check_github_token():
    """فحص وجود وصحة GitHub Token"""
    print_status("فحص GitHub Token...", "info")
    
    token = os.getenv('GITHUB_TOKEN')
    if not token:
        print_status("GITHUB_TOKEN غير موجود في متغيرات البيئة", "error")
        return False
    
    if len(token) < 20:
        print_status(f"GITHUB_TOKEN قصير جداً (الطول: {len(token)})", "error")
        return False
    
    if not token.startswith(('ghp_', 'github_pat_')):
        print_status("GITHUB_TOKEN لا يبدأ بالبادئة الصحيحة", "warning")
    
    print_status(f"GITHUB_TOKEN موجود (الطول: {len(token)})", "success")
    return True

def test_github_api():
    """اختبار الوصول لـ GitHub API"""
    print_status("اختبار GitHub API...", "info")
    
    try:
        result = subprocess.run([
            'curl', '-s', '-H', f'Authorization: token {os.getenv("GITHUB_TOKEN")}',
            'https://api.github.com/user'
        ], capture_output=True, text=True, timeout=10)
        
        if result.returncode == 0:
            user_data = json.loads(result.stdout)
            if 'login' in user_data:
                print_status(f"GitHub API يعمل - المستخدم: {user_data['login']}", "success")
                return True
        
        print_status("فشل في الوصول لـ GitHub API", "error")
        return False
        
    except Exception as e:
        print_status(f"خطأ في اختبار GitHub API: {e}", "error")
        return False

def fix_mcp_config():
    """إصلاح تكوين MCP"""
    print_status("إصلاح تكوين MCP...", "info")
    
    config_path = Path('.kiro/settings/mcp.json')
    
    if not config_path.exists():
        print_status("ملف mcp.json غير موجود", "error")
        return False
    
    try:
        with open(config_path, 'r', encoding='utf-8') as f:
            config = json.load(f)
        
        # تحديث تكوين GitHub
        github_config = {
            "command": "npx",
            "args": ["-y", "@modelcontextprotocol/server-github"],
            "env": {
                "GITHUB_TOKEN": "${GITHUB_TOKEN}",
                "FASTMCP_LOG_LEVEL": "ERROR",
                "NODE_ENV": "production"
            },
            "disabled": False,
            "timeout": 30000,
            "retries": 3,
            "autoApprove": [
                "search_repositories",
                "get_file_contents",
                "list_issues",
                "get_issue",
                "list_pull_requests",
                "get_pull_request",
                "get_pull_request_files",
                "list_commits",
                "search_code",
                "search_issues",
                "search_users",
                "create_issue",
                "update_issue",
                "add_issue_comment",
                "create_pull_request",
                "create_or_update_file",
                "push_files",
                "create_branch",
                "fork_repository"
            ]
        }
        
        config['mcpServers']['github'] = github_config
        
        # حفظ التكوين المحدث
        with open(config_path, 'w', encoding='utf-8') as f:
            json.dump(config, f, indent=2, ensure_ascii=False)
        
        print_status("تم تحديث تكوين MCP بنجاح", "success")
        return True
        
    except Exception as e:
        print_status(f"خطأ في تحديث تكوين MCP: {e}", "error")
        return False

def test_mcp_package():
    """اختبار حزمة GitHub MCP"""
    print_status("اختبار حزمة GitHub MCP...", "info")
    
    try:
        result = subprocess.run([
            'npx', '-y', '@modelcontextprotocol/server-github', '--help'
        ], capture_output=True, text=True, timeout=30)
        
        if result.returncode == 0:
            print_status("حزمة GitHub MCP تعمل بشكل صحيح", "success")
            return True
        else:
            print_status("مشكلة في حزمة GitHub MCP", "error")
            return False
            
    except subprocess.TimeoutExpired:
        print_status("انتهت مهلة اختبار حزمة GitHub MCP", "warning")
        return False
    except Exception as e:
        print_status(f"خطأ في اختبار حزمة GitHub MCP: {e}", "error")
        return False

def create_test_report():
    """إنشاء تقرير اختبار"""
    print_status("إنشاء تقرير الاختبار...", "info")
    
    report = {
        "timestamp": "2025-12-15T10:30:00Z",
        "github_token_check": check_github_token(),
        "github_api_test": test_github_api(),
        "mcp_config_fix": fix_mcp_config(),
        "mcp_package_test": test_mcp_package()
    }
    
    # حفظ التقرير
    with open('github_integration_report.json', 'w', encoding='utf-8') as f:
        json.dump(report, f, indent=2, ensure_ascii=False)
    
    # حساب النتيجة الإجمالية
    passed_tests = sum(1 for test in report.values() if test is True)
    total_tests = len([k for k in report.keys() if k != 'timestamp'])
    success_rate = (passed_tests / total_tests) * 100
    
    print_status(f"تم إنشاء التقرير: github_integration_report.json", "success")
    print_status(f"معدل النجاح: {success_rate:.1f}% ({passed_tests}/{total_tests})", 
                "success" if success_rate >= 75 else "warning")
    
    return success_rate >= 75

def main():
    """الدالة الرئيسية"""
    print("🔧 سكريبت إصلاح GitHub MCP Server")
    print("=" * 50)
    
    # تشغيل جميع الاختبارات والإصلاحات
    success = True
    
    if not check_github_token():
        success = False
    
    if not test_github_api():
        success = False
    
    if not fix_mcp_config():
        success = False
    
    if not test_mcp_package():
        print_status("تحذير: مشكلة في حزمة MCP، لكن قد تعمل مع Kiro", "warning")
    
    # إنشاء التقرير
    report_success = create_test_report()
    
    print("\n" + "=" * 50)
    if success and report_success:
        print_status("🎉 تم إصلاح GitHub MCP بنجاح!", "success")
        print_status("يمكنك الآن إعادة تشغيل Kiro لتطبيق التغييرات", "info")
        sys.exit(0)
    else:
        print_status("⚠️ بعض المشاكل تحتاج لإصلاح يدوي", "warning")
        print_status("راجع التقرير في github_integration_report.json", "info")
        sys.exit(1)

if __name__ == "__main__":
    main()