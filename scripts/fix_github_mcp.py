#!/usr/bin/env python3
"""
سكريبت إصلاح خادم GitHub MCP - حل شامل
يقوم بإصلاح جميع المشاكل المُحددة تلقائياً

المؤلف: فريق وكلاء تطوير مشروع بصير
التاريخ: 12 ديسمبر 2025
الحالة: مُختبر ومُؤكد العمل
"""

import json
import os
import sys
from datetime import datetime

def fix_github_mcp_server():
    """إصلاح شامل لخادم GitHub MCP"""
    
    print("🔧 بدء إصلاح خادم GitHub MCP...")
    
    config_path = os.path.expanduser('~/.kiro/settings/mcp.json')
    
    # التحقق من وجود ملف التكوين
    if not os.path.exists(config_path):
        print(f"❌ ملف التكوين غير موجود: {config_path}")
        return False
    
    # إنشاء نسخة احتياطية
    backup_path = f"{config_path}.backup.{datetime.now().strftime('%Y%m%d_%H%M%S')}"
    try:
        os.system(f"cp '{config_path}' '{backup_path}'")
        print(f"✅ تم إنشاء نسخة احتياطية: {backup_path}")
    except Exception as e:
        print(f"⚠️ تحذير: فشل في إنشاء نسخة احتياطية: {e}")
    
    # قراءة التكوين الحالي
    try:
        with open(config_path, 'r') as f:
            config = json.load(f)
    except Exception as e:
        print(f"❌ فشل في قراءة ملف التكوين: {e}")
        return False
    
    # الحصول على التوكن الحالي
    existing_token = '${GITHUB_TOKEN}'
    if 'mcpServers' in config and 'github' in config['mcpServers']:
        github_env = config['mcpServers']['github'].get('env', {})
        existing_token = <credential-fixture>('GITHUB_PERSONAL_ACCESS_TOKEN', '${GITHUB_TOKEN}')
    
    print(f"🔑 استخدام التوكن: {existing_token[:20]}..." if existing_token != '${GITHUB_TOKEN}' else "🔑 استخدام متغير البيئة: ${GITHUB_TOKEN}")
    
    # التكوين الجديد المُحسن
    github_config = {
        'command': 'npx',
        'args': ['-y', '@modelcontextprotocol/server-github'],
        'env': {
            'GITHUB_PERSONAL_ACCESS_TOKEN': existing_token,
            'FASTMCP_LOG_LEVEL': 'ERROR'
        },
        'disabled': False,
        'autoApprove': [
            'search_repositories',
            'get_file_contents', 
            'list_issues',
            'get_issue'
        ]
    }
    
    # تطبيق الإصلاح
    if 'mcpServers' not in config:
        config['mcpServers'] = {}
    
    config['mcpServers']['github'] = github_config
    
    # حفظ التكوين المُحدث
    try:
        with open(config_path, 'w') as f:
            json.dump(config, f, indent=2)
        print('✅ تم إصلاح خادم GitHub MCP بنجاح')
    except Exception as e:
        print(f"❌ فشل في حفظ التكوين: {e}")
        return False
    
    print('🔄 يرجى إعادة تشغيل Kiro لتطبيق التغييرات')
    print('📋 للتحقق من النجاح، راقب السجلات بحثاً عن رسائل timeout')
    
    return True

def test_github_connection():
    """اختبار الاتصال بـ GitHub API"""
    
    print("\n🧪 اختبار الاتصال بـ GitHub...")
    
    # اختبار متغير البيئة
    github_token = <credential-fixture>('GITHUB_TOKEN')
    if not github_token:
        print("⚠️ تحذير: GITHUB_TOKEN غير موجود في متغيرات البيئة")
        return False
    
    print(f"✅ GITHUB_TOKEN موجود (الطول: {len(github_token)})")
    
    # اختبار GitHub API
    import subprocess
    try:
        result = subprocess.run([
            'curl', '-s', '-H', f'Authorization: token {github_token}',
            'https://api.github.com/user'
        ], capture_output=True, text=True, timeout=10)
        
        if result.returncode == 0 and 'login' in result.stdout:
            print("✅ GitHub API يعمل بشكل صحيح")
            return True
        else:
            print("❌ فشل في الاتصال بـ GitHub API")
            return False
    except Exception as e:
        print(f"❌ خطأ في اختبار GitHub API: {e}")
        return False

def main():
    """الدالة الرئيسية"""
    
    print("=" * 60)
    print("🛠️  سكريبت إصلاح خادم GitHub MCP")
    print("   فريق وكلاء تطوير مشروع بصير")
    print("=" * 60)
    
    # اختبار الاتصال أولاً
    if not test_github_connection():
        print("\n⚠️ تحذير: مشاكل في الاتصال بـ GitHub قد تؤثر على الأداء")
        response = input("هل تريد المتابعة؟ (y/N): ")
        if response.lower() != 'y':
            print("❌ تم إلغاء العملية")
            return False
    
    # تطبيق الإصلاح
    success = fix_github_mcp_server()
    
    if success:
        print("\n🎉 تم الإصلاح بنجاح!")
        print("📖 للمزيد من التفاصيل، راجع: .kiro/troubleshooting/mcp-github-complete-solution.md")
    else:
        print("\n❌ فشل في الإصلاح")
        print("📖 راجع الدليل الشامل: .kiro/troubleshooting/mcp-github-complete-solution.md")
    
    return success

if __name__ == '__main__':
    success = main()
    sys.exit(0 if success else 1)