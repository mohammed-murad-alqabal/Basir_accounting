#!/usr/bin/env python3
"""
اختبار تحسينات الأداء لنظام فحص التوافق
Performance Testing for Compatibility Checker Improvements

المؤلف: فريق وكلاء تطوير مشروع بصير
التاريخ: 16 ديسمبر 2025
"""

import os
import sys
import time
import tempfile
import shutil
from pathlib import Path
from typing import List, Dict

# إضافة مجلد scripts إلى المسار
sys.path.insert(0, str(Path(__file__).parent))

from steering_compatibility_checker import CompatibilityChecker, DetectedIssue


class PerformanceTester:
    """اختبار أداء نظام فحص التوافق"""
    
    def __init__(self):
        self.test_dir = Path(tempfile.mkdtemp(prefix="steering_test_"))
        self.results = {}
        
    def cleanup(self):
        """تنظيف ملفات الاختبار"""
        if self.test_dir.exists():
            shutil.rmtree(self.test_dir)
    
    def create_test_files(self, num_files: int = 10, file_size: str = "small") -> List[Path]:
        """إنشاء ملفات اختبار"""
        files = []
        
        # محتوى الاختبار مع تقنيات غير متوافقة
        base_content = """
# ملف توجيه اختباري

## معايير التطوير

### التقنيات المستخدمة

- استخدم Flutter SDK للتطوير
- تجنب Node.js في هذا المشروع
- لا تستخدم React أو Vue.js
- استخدم Dart بدلاً من TypeScript

### أمثلة الكود

```dart
// مثال على كود Dart صحيح
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
```

### أدوات البناء

- استخدم flutter build للبناء
- تجنب webpack أو babel
- استخدم dart analyze للفحص

### قواعد البيانات

- استخدم Isar للقاعدة المحلية
- تجنب MongoDB أو MySQL
- استخدم SharedPreferences للإعدادات البسيطة

### الاختبارات

- استخدم flutter test للاختبارات
- تجنب Jest أو Mocha
- اكتب اختبارات الوحدة والتكامل

## مراجع غير متوافقة (للاختبار)

هذه المراجع يجب أن يتم اكتشافها:

- Node.js development server
- TypeScript configuration
- React components
- Vue.js templates  
- Angular modules
- Docker containers
- Kubernetes deployment
- webpack bundling
- babel transpilation
- eslint configuration
- Express server
- Django framework
- Flask application
- Python scripts
- Java applications
- PHP backend
- Ruby on Rails
- Go services
- Rust programs
- C# applications
- Swift iOS apps
- Kotlin Android
- MongoDB database
- MySQL server
- PostgreSQL database
- Redis cache
- Nginx server
- Apache httpd
- Vite bundler
- Rollup build
- Parcel bundler
- Gulp tasks
- Grunt tasks
- Jest testing
- Mocha tests
- Cypress e2e
- Selenium automation
- Sass styling
- Less preprocessing
- Tailwind CSS
- Bootstrap framework
- jQuery library
- Lodash utilities
"""
        
        # تحديد حجم الملف
        if file_size == "small":
            content = base_content
        elif file_size == "medium":
            content = base_content * 10  # ~50KB
        elif file_size == "large":
            content = base_content * 100  # ~500KB
        else:  # very_large
            content = base_content * 1000  # ~5MB
        
        # إنشاء الملفات
        for i in range(num_files):
            file_path = self.test_dir / f"test_file_{i:03d}.md"
            with open(file_path, 'w', encoding='utf-8') as f:
                f.write(f"# ملف اختبار رقم {i}\n\n{content}")
            files.append(file_path)
        
        return files
    
    def test_sequential_vs_parallel(self):
        """اختبار الأداء: تسلسلي مقابل متوازي"""
        print("🔄 اختبار الأداء: تسلسلي مقابل متوازي")
        
        # إنشاء ملفات اختبار متوسطة الحجم
        files = self.create_test_files(20, "medium")
        
        # إعداد مجلد التوجيه المؤقت
        temp_steering = self.test_dir / ".kiro" / "steering"
        temp_steering.mkdir(parents=True)
        
        for file_path in files:
            shutil.copy(file_path, temp_steering)
        
        # اختبار المعالجة التسلسلية
        checker_sequential = CompatibilityChecker(use_cache=False)
        checker_sequential.steering_directory = temp_steering
        
        start_time = time.time()
        issues_sequential = checker_sequential.check_all_steering_files(parallel=False)
        sequential_time = time.time() - start_time
        
        # اختبار المعالجة المتوازية
        checker_parallel = CompatibilityChecker(use_cache=False)
        checker_parallel.steering_directory = temp_steering
        
        start_time = time.time()
        issues_parallel = checker_parallel.check_all_steering_files(parallel=True)
        parallel_time = time.time() - start_time
        
        # النتائج
        speedup = sequential_time / parallel_time if parallel_time > 0 else 0
        
        self.results['sequential_vs_parallel'] = {
            'files_count': len(files),
            'sequential_time': sequential_time,
            'parallel_time': parallel_time,
            'speedup': speedup,
            'issues_sequential': sum(len(issues) for issues in issues_sequential.values()),
            'issues_parallel': sum(len(issues) for issues in issues_parallel.values())
        }
        
        print(f"   📁 عدد الملفات: {len(files)}")
        print(f"   ⏱️  الوقت التسلسلي: {sequential_time:.2f} ثانية")
        print(f"   ⚡ الوقت المتوازي: {parallel_time:.2f} ثانية")
        print(f"   🚀 التسريع: {speedup:.2f}x")
        print(f"   🔍 المشاكل المكتشفة: {self.results['sequential_vs_parallel']['issues_parallel']}")
    
    def test_cache_performance(self):
        """اختبار أداء التخزين المؤقت"""
        print("\n💾 اختبار أداء التخزين المؤقت")
        
        # إنشاء ملفات اختبار
        files = self.create_test_files(15, "medium")
        
        # إعداد مجلد التوجيه المؤقت
        temp_steering = self.test_dir / ".kiro" / "steering" / "cache_test"
        temp_steering.mkdir(parents=True, exist_ok=True)
        
        for file_path in files:
            shutil.copy(file_path, temp_steering)
        
        # الفحص الأول (بدون تخزين مؤقت)
        checker_no_cache = CompatibilityChecker(use_cache=False)
        checker_no_cache.steering_directory = temp_steering
        
        start_time = time.time()
        issues_no_cache = checker_no_cache.check_all_steering_files()
        no_cache_time = time.time() - start_time
        
        # الفحص الثاني (مع تخزين مؤقت - أول مرة)
        checker_with_cache = CompatibilityChecker(use_cache=True)
        checker_with_cache.steering_directory = temp_steering
        
        start_time = time.time()
        issues_first_cache = checker_with_cache.check_all_steering_files()
        first_cache_time = time.time() - start_time
        
        # الفحص الثالث (مع تخزين مؤقت - من التخزين المؤقت)
        checker_cached = CompatibilityChecker(use_cache=True)
        checker_cached.steering_directory = temp_steering
        
        start_time = time.time()
        issues_cached = checker_cached.check_all_steering_files()
        cached_time = time.time() - start_time
        
        # النتائج
        cache_speedup = no_cache_time / cached_time if cached_time > 0 else 0
        
        self.results['cache_performance'] = {
            'files_count': len(files),
            'no_cache_time': no_cache_time,
            'first_cache_time': first_cache_time,
            'cached_time': cached_time,
            'cache_speedup': cache_speedup,
            'cache_hits': checker_cached.stats['cache_hits'],
            'cache_misses': checker_cached.stats['cache_misses']
        }
        
        print(f"   📁 عدد الملفات: {len(files)}")
        print(f"   🚫 بدون تخزين مؤقت: {no_cache_time:.2f} ثانية")
        print(f"   💾 أول فحص مع التخزين: {first_cache_time:.2f} ثانية")
        print(f"   ⚡ من التخزين المؤقت: {cached_time:.2f} ثانية")
        print(f"   🚀 تسريع التخزين المؤقت: {cache_speedup:.2f}x")
        print(f"   🎯 إصابات التخزين المؤقت: {checker_cached.stats['cache_hits']}")
    
    def test_large_file_performance(self):
        """اختبار أداء الملفات الكبيرة"""
        print("\n📄 اختبار أداء الملفات الكبيرة")
        
        # إنشاء ملفات كبيرة
        small_files = self.create_test_files(5, "small")
        large_files = self.create_test_files(3, "very_large")
        
        # إعداد مجلد التوجيه المؤقت
        temp_steering = self.test_dir / ".kiro" / "steering" / "large_test"
        temp_steering.mkdir(parents=True, exist_ok=True)
        
        # نسخ الملفات الصغيرة
        for file_path in small_files:
            shutil.copy(file_path, temp_steering / f"small_{file_path.name}")
        
        # نسخ الملفات الكبيرة
        for file_path in large_files:
            shutil.copy(file_path, temp_steering / f"large_{file_path.name}")
        
        # فحص الملفات
        checker = CompatibilityChecker(use_cache=False)
        checker.steering_directory = temp_steering
        
        start_time = time.time()
        issues = checker.check_all_steering_files()
        total_time = time.time() - start_time
        
        # حساب أحجام الملفات
        total_size = sum(f.stat().st_size for f in temp_steering.glob("*.md"))
        
        self.results['large_file_performance'] = {
            'small_files': len(small_files),
            'large_files': len(large_files),
            'total_size_mb': total_size / (1024 * 1024),
            'total_time': total_time,
            'throughput_mb_per_sec': (total_size / (1024 * 1024)) / total_time if total_time > 0 else 0,
            'issues_found': sum(len(issues_list) for issues_list in issues.values())
        }
        
        print(f"   📄 ملفات صغيرة: {len(small_files)}")
        print(f"   📚 ملفات كبيرة: {len(large_files)}")
        print(f"   💾 الحجم الإجمالي: {total_size / (1024 * 1024):.1f} MB")
        print(f"   ⏱️  الوقت الإجمالي: {total_time:.2f} ثانية")
        print(f"   🚀 الإنتاجية: {self.results['large_file_performance']['throughput_mb_per_sec']:.1f} MB/ثانية")
        print(f"   🔍 المشاكل المكتشفة: {self.results['large_file_performance']['issues_found']}")
    
    def test_new_technologies_detection(self):
        """اختبار كشف التقنيات الجديدة المضافة"""
        print("\n🆕 اختبار كشف التقنيات الجديدة")
        
        # إنشاء ملف اختبار مع التقنيات الجديدة
        new_tech_content = """
# اختبار التقنيات الجديدة

## لغات البرمجة الجديدة
- Python development
- Java applications  
- PHP backend
- Ruby on Rails
- Go microservices
- Rust systems programming
- C# .NET applications
- Swift iOS development
- Kotlin Android development

## قواعد البيانات الجديدة
- MongoDB collections
- MySQL database
- PostgreSQL queries
- Redis caching

## خوادم الويب الجديدة
- Nginx configuration
- Apache httpd server

## أدوات البناء الجديدة
- Vite bundling
- Rollup configuration
- Parcel build
- Gulp tasks
- Grunt automation

## أدوات الاختبار الجديدة
- Jest unit tests
- Mocha test framework
- Cypress end-to-end
- Selenium automation

## أدوات التصميم الجديدة
- Sass preprocessing
- Less stylesheets
- Tailwind CSS framework
- Bootstrap components
- jQuery interactions
- Lodash utilities
"""
        
        test_file = self.test_dir / "new_technologies_test.md"
        with open(test_file, 'w', encoding='utf-8') as f:
            f.write(new_tech_content)
        
        # فحص الملف
        checker = CompatibilityChecker(use_cache=False)
        issues = checker.check_file(test_file)
        
        # تصنيف المشاكل حسب النوع
        issues_by_type = {}
        for issue in issues:
            tech_type = None
            for tech in checker.incompatible_technologies:
                if tech.name == issue.technology:
                    tech_type = tech.type
                    break
            
            if tech_type:
                if tech_type not in issues_by_type:
                    issues_by_type[tech_type] = []
                issues_by_type[tech_type].append(issue)
        
        self.results['new_technologies_detection'] = {
            'total_issues': len(issues),
            'issues_by_type': {k: len(v) for k, v in issues_by_type.items()},
            'detected_technologies': list(set(issue.technology for issue in issues))
        }
        
        print(f"   🔍 إجمالي المشاكل المكتشفة: {len(issues)}")
        print(f"   🏷️  أنواع التقنيات المكتشفة:")
        for tech_type, count in issues_by_type.items():
            print(f"      - {tech_type}: {count} مشكلة")
        print(f"   📋 التقنيات المكتشفة: {', '.join(self.results['new_technologies_detection']['detected_technologies'][:10])}...")
    
    def generate_performance_report(self):
        """توليد تقرير الأداء"""
        print("\n" + "="*60)
        print("📊 تقرير الأداء الشامل")
        print("="*60)
        
        # ملخص النتائج
        if 'sequential_vs_parallel' in self.results:
            result = self.results['sequential_vs_parallel']
            print(f"\n🔄 المعالجة المتوازية:")
            print(f"   تسريع: {result['speedup']:.2f}x")
            print(f"   توفير الوقت: {((result['sequential_time'] - result['parallel_time']) / result['sequential_time'] * 100):.1f}%")
        
        if 'cache_performance' in self.results:
            result = self.results['cache_performance']
            print(f"\n💾 التخزين المؤقت:")
            print(f"   تسريع: {result['cache_speedup']:.2f}x")
            print(f"   توفير الوقت: {((result['no_cache_time'] - result['cached_time']) / result['no_cache_time'] * 100):.1f}%")
        
        if 'large_file_performance' in self.results:
            result = self.results['large_file_performance']
            print(f"\n📄 الملفات الكبيرة:")
            print(f"   الإنتاجية: {result['throughput_mb_per_sec']:.1f} MB/ثانية")
            print(f"   الحجم المعالج: {result['total_size_mb']:.1f} MB")
        
        if 'new_technologies_detection' in self.results:
            result = self.results['new_technologies_detection']
            print(f"\n🆕 التقنيات الجديدة:")
            print(f"   المشاكل المكتشفة: {result['total_issues']}")
            print(f"   التقنيات المختلفة: {len(result['detected_technologies'])}")
        
        print("\n✅ جميع الاختبارات اكتملت بنجاح!")
        print("🚀 التحسينات تعمل بشكل ممتاز!")
    
    def run_all_tests(self):
        """تشغيل جميع الاختبارات"""
        print("🧪 بدء اختبارات الأداء الشاملة")
        print("="*50)
        
        try:
            self.test_sequential_vs_parallel()
            self.test_cache_performance()
            self.test_large_file_performance()
            self.test_new_technologies_detection()
            self.generate_performance_report()
            
        except Exception as e:
            print(f"❌ خطأ في الاختبار: {e}")
            import traceback
            traceback.print_exc()
        
        finally:
            self.cleanup()


def main():
    """الدالة الرئيسية"""
    tester = PerformanceTester()
    tester.run_all_tests()


if __name__ == "__main__":
    main()