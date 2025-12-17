#!/usr/bin/env python3
"""
نظام فحص التوافق التلقائي لملفات التوجيه - محسن للأداء
Automatic Compatibility Checker for Steering Files - Performance Enhanced

يفحص ملفات التوجيه للبحث عن مراجع لتقنيات غير متوافقة مع مكدس Flutter/Dart
ويمنع إضافة مراجع جديدة غير متوافقة.

المؤلف: فريق وكلاء تطوير مشروع بصير
التاريخ: 16 ديسمبر 2025
الإصدار: 2.0 - محسن للأداء
"""

import os
import re
import json
import sys
import mmap
import threading
import concurrent.futures
from pathlib import Path
from typing import List, Dict, Set, Tuple, Optional
from dataclasses import dataclass
from datetime import datetime
import argparse
import time
import hashlib


@dataclass
class IncompatibleTechnology:
    """نموذج التقنية غير المتوافقة"""
    name: str
    type: str
    reason: str
    replacement: str
    patterns: List[str]


@dataclass
class DetectedIssue:
    """مشكلة مكتشفة في الملف"""
    file_path: str
    line_number: int
    line_content: str
    technology: str
    pattern_matched: str
    severity: str
    suggestion: str


@dataclass
class FileCache:
    """تخزين مؤقت لنتائج الفحص"""
    file_hash: str
    last_modified: float
    issues: List[DetectedIssue]
    scan_time: float


class PerformanceOptimizer:
    """محسن الأداء للملفات الكبيرة"""
    
    def __init__(self, cache_dir: str = ".cache/compatibility"):
        self.cache_dir = Path(cache_dir)
        self.cache_dir.mkdir(parents=True, exist_ok=True)
        self.cache_file = self.cache_dir / "scan_cache.json"
        self.cache = self._load_cache()
        self.max_workers = min(32, (os.cpu_count() or 1) + 4)
        
    def _load_cache(self) -> Dict[str, FileCache]:
        """تحميل التخزين المؤقت"""
        if self.cache_file.exists():
            try:
                with open(self.cache_file, 'r', encoding='utf-8') as f:
                    cache_data = json.load(f)
                    return {
                        path: FileCache(
                            file_hash=data['file_hash'],
                            last_modified=data['last_modified'],
                            issues=[
                                DetectedIssue(**issue) for issue in data['issues']
                            ],
                            scan_time=data['scan_time']
                        )
                        for path, data in cache_data.items()
                    }
            except Exception as e:
                print(f"تحذير: فشل في تحميل التخزين المؤقت: {e}")
        return {}
    
    def _save_cache(self):
        """حفظ التخزين المؤقت"""
        try:
            cache_data = {}
            for path, cache_entry in self.cache.items():
                cache_data[path] = {
                    'file_hash': cache_entry.file_hash,
                    'last_modified': cache_entry.last_modified,
                    'issues': [
                        {
                            'file_path': issue.file_path,
                            'line_number': issue.line_number,
                            'line_content': issue.line_content,
                            'technology': issue.technology,
                            'pattern_matched': issue.pattern_matched,
                            'severity': issue.severity,
                            'suggestion': issue.suggestion
                        }
                        for issue in cache_entry.issues
                    ],
                    'scan_time': cache_entry.scan_time
                }
            
            with open(self.cache_file, 'w', encoding='utf-8') as f:
                json.dump(cache_data, f, ensure_ascii=False, indent=2)
        except Exception as e:
            print(f"تحذير: فشل في حفظ التخزين المؤقت: {e}")
    
    def get_file_hash(self, file_path: Path) -> str:
        """حساب hash للملف"""
        try:
            with open(file_path, 'rb') as f:
                return hashlib.md5(f.read()).hexdigest()
        except Exception:
            return ""
    
    def is_cache_valid(self, file_path: Path) -> bool:
        """فحص صحة التخزين المؤقت للملف"""
        file_str = str(file_path)
        if file_str not in self.cache:
            return False
            
        try:
            stat = file_path.stat()
            cache_entry = self.cache[file_str]
            
            # فحص وقت التعديل
            if stat.st_mtime != cache_entry.last_modified:
                return False
                
            # فحص hash الملف
            current_hash = self.get_file_hash(file_path)
            if current_hash != cache_entry.file_hash:
                return False
                
            return True
        except Exception:
            return False
    
    def get_cached_result(self, file_path: Path) -> Optional[List[DetectedIssue]]:
        """الحصول على النتيجة من التخزين المؤقت"""
        if self.is_cache_valid(file_path):
            return self.cache[str(file_path)].issues
        return None
    
    def cache_result(self, file_path: Path, issues: List[DetectedIssue], scan_time: float):
        """حفظ النتيجة في التخزين المؤقت"""
        try:
            stat = file_path.stat()
            file_hash = self.get_file_hash(file_path)
            
            self.cache[str(file_path)] = FileCache(
                file_hash=file_hash,
                last_modified=stat.st_mtime,
                issues=issues,
                scan_time=scan_time
            )
        except Exception as e:
            print(f"تحذير: فشل في حفظ النتيجة في التخزين المؤقت: {e}")
    
    def cleanup_cache(self):
        """تنظيف التخزين المؤقت من الملفات المحذوفة"""
        to_remove = []
        for file_path in self.cache.keys():
            if not Path(file_path).exists():
                to_remove.append(file_path)
        
        for file_path in to_remove:
            del self.cache[file_path]


class CompatibilityChecker:
    """محلل التوافق الرئيسي - محسن للأداء"""
    
    def __init__(self, use_cache: bool = True, max_workers: Optional[int] = None):
        self.incompatible_technologies = self._load_incompatible_technologies_from_file()
        self.steering_directory = Path(".kiro/steering")
        self.reports_directory = Path("reports/compatibility")
        self.reports_directory.mkdir(parents=True, exist_ok=True)
        
        # تحسينات الأداء
        self.use_cache = use_cache
        self.performance_optimizer = PerformanceOptimizer() if use_cache else None
        self.max_workers = max_workers or min(32, (os.cpu_count() or 1) + 4)
        
        # تجميع الأنماط لتحسين الأداء
        self.compiled_patterns = self._compile_patterns()
        
        # إحصائيات الأداء
        self.stats = {
            'files_scanned': 0,
            'cache_hits': 0,
            'cache_misses': 0,
            'total_scan_time': 0.0,
            'average_scan_time': 0.0
        }
    
    def _load_incompatible_technologies_from_file(self) -> List[IncompatibleTechnology]:
        """تحميل قائمة التقنيات غير المتوافقة من ملف JSON"""
        config_file = Path(__file__).parent / "incompatible_technologies.json"
        
        if not config_file.exists():
            print(f"تحذير: ملف التكوين غير موجود: {config_file}")
            return self._load_incompatible_technologies()
        
        try:
            with open(config_file, 'r', encoding='utf-8') as f:
                config = json.load(f)
            
            technologies = []
            for tech_data in config.get('incompatible_technologies', []):
                technologies.append(IncompatibleTechnology(
                    name=tech_data['name'],
                    type=tech_data['type'],
                    reason=tech_data['reason'],
                    replacement=tech_data['replacement'],
                    patterns=tech_data['patterns']
                ))
            
            return technologies
            
        except Exception as e:
            print(f"خطأ في تحميل ملف التكوين: {e}")
            print("استخدام التكوين الافتراضي...")
            return self._load_incompatible_technologies()
    
    def _compile_patterns(self) -> Dict[str, List[Tuple[re.Pattern, IncompatibleTechnology]]]:
        """تجميع الأنماط مسبقاً لتحسين الأداء"""
        compiled = {}
        
        for tech in self.incompatible_technologies:
            tech_patterns = []
            for pattern in tech.patterns:
                try:
                    compiled_pattern = re.compile(pattern, re.IGNORECASE)
                    tech_patterns.append((compiled_pattern, tech))
                except re.error as e:
                    print(f"تحذير: نمط غير صحيح '{pattern}' للتقنية {tech.name}: {e}")
            
            if tech_patterns:
                compiled[tech.name] = tech_patterns
        
        return compiled
    
    def _load_incompatible_technologies(self) -> List[IncompatibleTechnology]:
        """تحميل قائمة التقنيات غير المتوافقة"""
        return [
            # تقنيات الويب
            IncompatibleTechnology(
                name="Node.js",
                type="runtime",
                reason="غير متوافق مع تطوير Flutter المحلي",
                replacement="Flutter SDK",
                patterns=[
                    r'\bNode\.js\b',
                    r'\bnodejs\b',
                    r'\bnpm\s+install\b',
                    r'\bnpm\s+run\b',
                    r'\byarn\s+install\b',
                    r'\byarn\s+start\b',
                    r'package\.json',
                    r'node_modules'
                ]
            ),
            IncompatibleTechnology(
                name="TypeScript",
                type="language",
                reason="يجب استخدام Dart بدلاً من TypeScript",
                replacement="Dart",
                patterns=[
                    r'\bTypeScript\b',
                    r'\.ts\b',
                    r'\.tsx\b',
                    r'\btsc\b',
                    r'tsconfig\.json'
                ]
            ),
            IncompatibleTechnology(
                name="JavaScript",
                type="language", 
                reason="يجب استخدام Dart بدلاً من JavaScript",
                replacement="Dart",
                patterns=[
                    r'\bJavaScript\b',
                    r'\.js\b',
                    r'\.jsx\b',
                    r'\bES6\b',
                    r'\bES2015\b'
                ]
            ),
            IncompatibleTechnology(
                name="React",
                type="web_framework",
                reason="يجب استخدام Flutter بدلاً من React",
                replacement="Flutter",
                patterns=[
                    r'\bReact\b',
                    r'\bReactJS\b',
                    r'\bReact\.js\b',
                    r'create-react-app',
                    r'react-dom'
                ]
            ),
            IncompatibleTechnology(
                name="Vue",
                type="web_framework",
                reason="يجب استخدام Flutter بدلاً من Vue",
                replacement="Flutter",
                patterns=[
                    r'\bVue\b',
                    r'\bVue\.js\b',
                    r'\bVuejs\b',
                    r'vue-cli'
                ]
            ),
            IncompatibleTechnology(
                name="Angular",
                type="web_framework",
                reason="يجب استخدام Flutter بدلاً من Angular",
                replacement="Flutter",
                patterns=[
                    r'\bAngular\b',
                    r'\bAngularJS\b',
                    r'@angular/',
                    r'ng\s+new',
                    r'ng\s+serve'
                ]
            ),
            IncompatibleTechnology(
                name="Docker",
                type="infrastructure",
                reason="غير مطلوب للتطبيقات المحلية",
                replacement="Local development",
                patterns=[
                    r'\bDocker\b',
                    r'Dockerfile',
                    r'docker-compose',
                    r'docker\s+run',
                    r'docker\s+build'
                ]
            ),
            IncompatibleTechnology(
                name="Kubernetes",
                type="infrastructure", 
                reason="غير مطلوب للتطبيقات المحلية",
                replacement="Local development",
                patterns=[
                    r'\bKubernetes\b',
                    r'\bk8s\b',
                    r'kubectl',
                    r'deployment\.yaml',
                    r'service\.yaml'
                ]
            ),
            IncompatibleTechnology(
                name="webpack",
                type="build_tool",
                reason="يجب استخدام flutter build",
                replacement="flutter build",
                patterns=[
                    r'\bwebpack\b',
                    r'webpack\.config',
                    r'webpack-dev-server'
                ]
            ),
            IncompatibleTechnology(
                name="babel",
                type="build_tool",
                reason="غير مطلوب مع Dart",
                replacement="dart compile",
                patterns=[
                    r'\bbabel\b',
                    r'\.babelrc',
                    r'babel\.config'
                ]
            ),
            IncompatibleTechnology(
                name="eslint",
                type="linting_tool",
                reason="يجب استخدام dart analyze",
                replacement="dart analyze",
                patterns=[
                    r'\beslint\b',
                    r'\.eslintrc',
                    r'eslint\.config'
                ]
            ),
            # تقنيات الخادم
            IncompatibleTechnology(
                name="Express",
                type="server_framework",
                reason="غير مطلوب للتطبيقات المحلية",
                replacement="Local API or Firebase",
                patterns=[
                    r'\bExpress\b',
                    r'\bexpress\(\)',
                    r'express\.Router'
                ]
            ),
            IncompatibleTechnology(
                name="Django",
                type="server_framework",
                reason="غير مطلوب للتطبيقات المحلية",
                replacement="Local API or Firebase",
                patterns=[
                    r'\bDjango\b',
                    r'django-admin',
                    r'manage\.py'
                ]
            ),
            IncompatibleTechnology(
                name="Flask",
                type="server_framework",
                reason="غير مطلوب للتطبيقات المحلية", 
                replacement="Local API or Firebase",
                patterns=[
                    r'\bFlask\b',
                    r'from flask import',
                    r'app = Flask'
                ]
            )
        ]
    
    def check_file(self, file_path: Path) -> List[DetectedIssue]:
        """فحص ملف واحد للبحث عن مراجع غير متوافقة - محسن للأداء"""
        start_time = time.time()
        
        # فحص التخزين المؤقت أولاً
        if self.use_cache and self.performance_optimizer:
            cached_result = self.performance_optimizer.get_cached_result(file_path)
            if cached_result is not None:
                self.stats['cache_hits'] += 1
                return cached_result
            self.stats['cache_misses'] += 1
        
        issues = []
        
        try:
            # استخدام memory mapping للملفات الكبيرة
            file_size = file_path.stat().st_size
            
            if file_size > 10 * 1024 * 1024:  # 10MB
                issues = self._check_large_file_with_mmap(file_path)
            else:
                issues = self._check_regular_file(file_path)
                
        except Exception as e:
            print(f"خطأ في قراءة الملف {file_path}: {e}")
        
        # حفظ في التخزين المؤقت
        scan_time = time.time() - start_time
        if self.use_cache and self.performance_optimizer:
            self.performance_optimizer.cache_result(file_path, issues, scan_time)
        
        # تحديث الإحصائيات
        self.stats['files_scanned'] += 1
        self.stats['total_scan_time'] += scan_time
        self.stats['average_scan_time'] = self.stats['total_scan_time'] / self.stats['files_scanned']
        
        return issues
    
    def _check_regular_file(self, file_path: Path) -> List[DetectedIssue]:
        """فحص ملف عادي الحجم"""
        issues = []
        
        with open(file_path, 'r', encoding='utf-8') as f:
            lines = f.readlines()
        
        for line_num, line in enumerate(lines, 1):
            issues.extend(self._check_line(line, line_num, file_path))
        
        return issues
    
    def _check_large_file_with_mmap(self, file_path: Path) -> List[DetectedIssue]:
        """فحص ملف كبير باستخدام memory mapping"""
        issues = []
        
        try:
            with open(file_path, 'r', encoding='utf-8') as f:
                with mmap.mmap(f.fileno(), 0, access=mmap.ACCESS_READ) as mmapped_file:
                    content = mmapped_file.read().decode('utf-8')
                    lines = content.splitlines()
                    
                    # معالجة متوازية للملفات الكبيرة جداً
                    if len(lines) > 10000:
                        issues = self._check_lines_parallel(lines, file_path)
                    else:
                        for line_num, line in enumerate(lines, 1):
                            issues.extend(self._check_line(line, line_num, file_path))
        except Exception as e:
            print(f"فشل في استخدام memory mapping للملف {file_path}: {e}")
            # العودة للطريقة العادية
            issues = self._check_regular_file(file_path)
        
        return issues
    
    def _check_lines_parallel(self, lines: List[str], file_path: Path) -> List[DetectedIssue]:
        """فحص الأسطر بشكل متوازي للملفات الكبيرة جداً"""
        issues = []
        chunk_size = max(100, len(lines) // self.max_workers)
        
        def check_chunk(chunk_data):
            chunk_issues = []
            start_line, chunk_lines = chunk_data
            for i, line in enumerate(chunk_lines):
                line_num = start_line + i + 1
                chunk_issues.extend(self._check_line(line, line_num, file_path))
            return chunk_issues
        
        # تقسيم الأسطر إلى chunks
        chunks = []
        for i in range(0, len(lines), chunk_size):
            chunk = lines[i:i + chunk_size]
            chunks.append((i, chunk))
        
        # معالجة متوازية
        with concurrent.futures.ThreadPoolExecutor(max_workers=self.max_workers) as executor:
            future_to_chunk = {executor.submit(check_chunk, chunk): chunk for chunk in chunks}
            
            for future in concurrent.futures.as_completed(future_to_chunk):
                try:
                    chunk_issues = future.result()
                    issues.extend(chunk_issues)
                except Exception as e:
                    print(f"خطأ في معالجة chunk: {e}")
        
        return issues
    
    def _check_line(self, line: str, line_num: int, file_path: Path) -> List[DetectedIssue]:
        """فحص سطر واحد للبحث عن مراجع غير متوافقة"""
        issues = []
        
        # تجاهل الأسطر الفارغة والتعليقات
        line_stripped = line.strip()
        if not line_stripped or line_stripped.startswith('#'):
            return issues
        
        for tech_name, patterns in self.compiled_patterns.items():
            for compiled_pattern, tech in patterns:
                match = compiled_pattern.search(line)
                if match:
                    # تجاهل التعليقات التي تشرح ما يجب تجنبه
                    if self._is_explanatory_comment(line, tech.name):
                        continue
                    
                    severity = self._determine_severity_from_config(tech.type)
                    suggestion = self._generate_suggestion(tech, line)
                    
                    issues.append(DetectedIssue(
                        file_path=str(file_path),
                        line_number=line_num,
                        line_content=line.strip(),
                        technology=tech.name,
                        pattern_matched=compiled_pattern.pattern,
                        severity=severity,
                        suggestion=suggestion
                    ))
                    break  # تجنب التكرار لنفس السطر
            
            if issues:  # إذا وجدنا مشكلة، لا نحتاج للبحث في باقي التقنيات لهذا السطر
                break
        
        return issues
    
    def _is_explanatory_comment(self, line: str, tech_name: str) -> bool:
        """تحديد ما إذا كان السطر تعليق توضيحي لما يجب تجنبه"""
        explanatory_keywords = [
            'تجنب', 'لا تستخدم', 'بدلاً من', 'instead of', 'avoid', 'don\'t use',
            'للإزالة', 'للاستبدال', 'غير متوافق', 'incompatible'
        ]
        
        line_lower = line.lower()
        return any(keyword in line_lower for keyword in explanatory_keywords)
    
    def _determine_severity(self, tech_type: str, line: str) -> str:
        """تحديد مستوى خطورة المشكلة - الطريقة القديمة"""
        if tech_type in ['runtime', 'language']:
            return 'high'
        elif tech_type in ['web_framework', 'server_framework']:
            return 'high'
        elif tech_type in ['build_tool', 'linting_tool']:
            return 'medium'
        else:
            return 'low'
    
    def _determine_severity_from_config(self, tech_type: str) -> str:
        """تحديد مستوى خطورة المشكلة من ملف التكوين"""
        try:
            config_file = Path(__file__).parent / "incompatible_technologies.json"
            if config_file.exists():
                with open(config_file, 'r', encoding='utf-8') as f:
                    config = json.load(f)
                    severity_mapping = config.get('severity_mapping', {})
                    return severity_mapping.get(tech_type, 'medium')
        except Exception:
            pass
        
        # العودة للطريقة القديمة في حالة الفشل
        return self._determine_severity(tech_type, "")
    
    def _generate_suggestion(self, tech: IncompatibleTechnology, line: str) -> str:
        """توليد اقتراح للإصلاح"""
        return f"استبدل '{tech.name}' بـ '{tech.replacement}'. السبب: {tech.reason}"
    
    def check_all_steering_files(self, parallel: bool = True) -> Dict[str, List[DetectedIssue]]:
        """فحص جميع ملفات التوجيه - محسن للأداء"""
        all_issues = {}
        
        if not self.steering_directory.exists():
            print(f"مجلد التوجيه غير موجود: {self.steering_directory}")
            return all_issues
        
        # البحث عن جميع ملفات .md في مجلد التوجيه
        md_files = list(self.steering_directory.rglob("*.md"))
        
        if not md_files:
            print("لم يتم العثور على ملفات .md في مجلد التوجيه")
            return all_issues
        
        print(f"فحص {len(md_files)} ملف...")
        
        if parallel and len(md_files) > 1:
            all_issues = self._check_files_parallel(md_files)
        else:
            all_issues = self._check_files_sequential(md_files)
        
        # تنظيف التخزين المؤقت
        if self.use_cache and self.performance_optimizer:
            self.performance_optimizer.cleanup_cache()
            self.performance_optimizer._save_cache()
        
        # طباعة إحصائيات الأداء
        self._print_performance_stats()
        
        return all_issues
    
    def _check_files_sequential(self, md_files: List[Path]) -> Dict[str, List[DetectedIssue]]:
        """فحص الملفات بشكل تسلسلي"""
        all_issues = {}
        
        for i, file_path in enumerate(md_files, 1):
            print(f"فحص الملف {i}/{len(md_files)}: {file_path.name}")
            issues = self.check_file(file_path)
            if issues:
                all_issues[str(file_path)] = issues
        
        return all_issues
    
    def _check_files_parallel(self, md_files: List[Path]) -> Dict[str, List[DetectedIssue]]:
        """فحص الملفات بشكل متوازي"""
        all_issues = {}
        
        def check_single_file(file_path):
            return str(file_path), self.check_file(file_path)
        
        print(f"استخدام {self.max_workers} عامل للمعالجة المتوازية...")
        
        with concurrent.futures.ThreadPoolExecutor(max_workers=self.max_workers) as executor:
            # إرسال جميع المهام
            future_to_file = {
                executor.submit(check_single_file, file_path): file_path 
                for file_path in md_files
            }
            
            # جمع النتائج
            completed = 0
            for future in concurrent.futures.as_completed(future_to_file):
                file_path = future_to_file[future]
                completed += 1
                
                try:
                    file_str, issues = future.result()
                    if issues:
                        all_issues[file_str] = issues
                    
                    print(f"مكتمل {completed}/{len(md_files)}: {file_path.name}")
                    
                except Exception as e:
                    print(f"خطأ في فحص الملف {file_path}: {e}")
        
        return all_issues
    
    def _print_performance_stats(self):
        """طباعة إحصائيات الأداء"""
        if self.stats['files_scanned'] > 0:
            print(f"\n📊 إحصائيات الأداء:")
            print(f"   الملفات المفحوصة: {self.stats['files_scanned']}")
            print(f"   إصابات التخزين المؤقت: {self.stats['cache_hits']}")
            print(f"   إخفاقات التخزين المؤقت: {self.stats['cache_misses']}")
            print(f"   إجمالي وقت الفحص: {self.stats['total_scan_time']:.2f} ثانية")
            print(f"   متوسط وقت الفحص: {self.stats['average_scan_time']:.3f} ثانية/ملف")
            
            if self.stats['cache_hits'] + self.stats['cache_misses'] > 0:
                cache_hit_rate = self.stats['cache_hits'] / (self.stats['cache_hits'] + self.stats['cache_misses']) * 100
                print(f"   معدل إصابة التخزين المؤقت: {cache_hit_rate:.1f}%")
    
    def generate_report(self, all_issues: Dict[str, List[DetectedIssue]]) -> str:
        """توليد تقرير شامل"""
        timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        
        # إحصائيات عامة
        total_files_checked = len(list(self.steering_directory.rglob("*.md")))
        files_with_issues = len(all_issues)
        total_issues = sum(len(issues) for issues in all_issues.values())
        
        # تصنيف المشاكل حسب الخطورة
        severity_counts = {'high': 0, 'medium': 0, 'low': 0}
        tech_counts = {}
        
        for issues in all_issues.values():
            for issue in issues:
                severity_counts[issue.severity] += 1
                tech_counts[issue.technology] = tech_counts.get(issue.technology, 0) + 1
        
        # بناء التقرير
        report = f"""# تقرير فحص التوافق التلقائي

**التاريخ:** {timestamp}  
**المؤلف:** فريق وكلاء تطوير مشروع بصير

## الملخص التنفيذي

- **إجمالي الملفات المفحوصة:** {total_files_checked}
- **الملفات التي تحتوي على مشاكل:** {files_with_issues}
- **إجمالي المشاكل المكتشفة:** {total_issues}

## تصنيف المشاكل حسب الخطورة

| الخطورة | العدد | النسبة |
|---------|-------|--------|
| عالية | {severity_counts['high']} | {(severity_counts['high']/total_issues*100):.1f}% |
| متوسطة | {severity_counts['medium']} | {(severity_counts['medium']/total_issues*100):.1f}% |
| منخفضة | {severity_counts['low']} | {(severity_counts['low']/total_issues*100):.1f}% |

## التقنيات الأكثر ظهوراً

"""
        
        # ترتيب التقنيات حسب عدد المراجع
        sorted_techs = sorted(tech_counts.items(), key=lambda x: x[1], reverse=True)
        for tech, count in sorted_techs[:10]:  # أعلى 10 تقنيات
            report += f"- **{tech}:** {count} مرجع\n"
        
        report += "\n## تفاصيل المشاكل\n\n"
        
        # تفاصيل كل ملف
        for file_path, issues in all_issues.items():
            report += f"### {file_path}\n\n"
            report += f"**عدد المشاكل:** {len(issues)}\n\n"
            
            for issue in issues:
                report += f"**السطر {issue.line_number}:** {issue.severity.upper()}\n"
                report += f"```\n{issue.line_content}\n```\n"
                report += f"**التقنية:** {issue.technology}\n"
                report += f"**الاقتراح:** {issue.suggestion}\n\n"
        
        # التوصيات
        report += """## التوصيات

### إجراءات فورية
1. إصلاح المشاكل عالية الخطورة أولاً
2. استبدال مراجع Node.js و TypeScript
3. تحديث أمثلة الكود لتستخدم Dart

### إجراءات متوسطة المدى
1. مراجعة جميع ملفات التوجيه
2. تحديث الأدلة والإرشادات
3. إضافة أمثلة Flutter محدثة

### إجراءات طويلة المدى
1. تطبيق فحوصات تلقائية في CI/CD
2. تدريب الفريق على المعايير الجديدة
3. مراقبة مستمرة للامتثال

---

**تم إنشاؤه بواسطة:** نظام فحص التوافق التلقائي  
**الإصدار:** 1.0
"""
        
        return report
    
    def save_report(self, report: str, format_type: str = 'markdown') -> str:
        """حفظ التقرير"""
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        
        if format_type == 'markdown':
            filename = f"compatibility_report_{timestamp}.md"
            filepath = self.reports_directory / filename
            
            with open(filepath, 'w', encoding='utf-8') as f:
                f.write(report)
        
        return str(filepath)
    
    def save_json_report(self, all_issues: Dict[str, List[DetectedIssue]]) -> str:
        """حفظ تقرير JSON للمعالجة التلقائية"""
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        filename = f"compatibility_issues_{timestamp}.json"
        filepath = self.reports_directory / filename
        
        # تحويل البيانات إلى قاموس قابل للتسلسل
        json_data = {
            "timestamp": datetime.now().isoformat(),
            "total_files": len(list(self.steering_directory.rglob("*.md"))),
            "files_with_issues": len(all_issues),
            "total_issues": sum(len(issues) for issues in all_issues.values()),
            "issues": {}
        }
        
        for file_path, issues in all_issues.items():
            json_data["issues"][file_path] = [
                {
                    "line_number": issue.line_number,
                    "line_content": issue.line_content,
                    "technology": issue.technology,
                    "pattern_matched": issue.pattern_matched,
                    "severity": issue.severity,
                    "suggestion": issue.suggestion
                }
                for issue in issues
            ]
        
        with open(filepath, 'w', encoding='utf-8') as f:
            json.dump(json_data, f, ensure_ascii=False, indent=2)
        
        return str(filepath)


def main():
    """الدالة الرئيسية - محسنة للأداء"""
    parser = argparse.ArgumentParser(
        description='فحص ملفات التوجيه للبحث عن مراجع غير متوافقة - الإصدار المحسن'
    )
    parser.add_argument(
        '--file', 
        help='فحص ملف واحد فقط'
    )
    parser.add_argument(
        '--output-format',
        choices=['markdown', 'json', 'both'],
        default='both',
        help='تنسيق التقرير المطلوب'
    )
    parser.add_argument(
        '--fail-on-issues',
        action='store_true',
        help='فشل البرنامج إذا وجدت مشاكل (للاستخدام في CI/CD)'
    )
    parser.add_argument(
        '--severity-threshold',
        choices=['low', 'medium', 'high'],
        default='medium',
        help='الحد الأدنى لخطورة المشاكل التي تسبب فشل البرنامج'
    )
    parser.add_argument(
        '--no-cache',
        action='store_true',
        help='تعطيل التخزين المؤقت (مفيد للاختبار)'
    )
    parser.add_argument(
        '--no-parallel',
        action='store_true',
        help='تعطيل المعالجة المتوازية'
    )
    parser.add_argument(
        '--max-workers',
        type=int,
        help='عدد العمال للمعالجة المتوازية (افتراضي: CPU cores + 4)'
    )
    parser.add_argument(
        '--performance-stats',
        action='store_true',
        help='عرض إحصائيات الأداء التفصيلية'
    )
    
    args = parser.parse_args()
    
    # إنشاء محلل التوافق مع الخيارات المحسنة
    checker = CompatibilityChecker(
        use_cache=not args.no_cache,
        max_workers=args.max_workers
    )
    
    if args.file:
        # فحص ملف واحد
        file_path = Path(args.file)
        if not file_path.exists():
            print(f"الملف غير موجود: {file_path}")
            sys.exit(1)
        
        issues = checker.check_file(file_path)
        if issues:
            print(f"تم العثور على {len(issues)} مشكلة في {file_path}:")
            for issue in issues:
                print(f"  السطر {issue.line_number}: {issue.technology} ({issue.severity})")
        else:
            print(f"لا توجد مشاكل في {file_path}")
    else:
        # فحص جميع الملفات
        print("🔍 بدء فحص جميع ملفات التوجيه...")
        start_time = time.time()
        
        all_issues = checker.check_all_steering_files(
            parallel=not args.no_parallel
        )
        
        total_time = time.time() - start_time
        print(f"⏱️  إجمالي وقت الفحص: {total_time:.2f} ثانية")
        
        if all_issues:
            total_issues = sum(len(issues) for issues in all_issues.values())
            print(f"تم العثور على {total_issues} مشكلة في {len(all_issues)} ملف")
            
            # توليد التقارير
            if args.output_format in ['markdown', 'both']:
                report = checker.generate_report(all_issues)
                report_path = checker.save_report(report)
                print(f"تم حفظ تقرير Markdown: {report_path}")
            
            if args.output_format in ['json', 'both']:
                json_path = checker.save_json_report(all_issues)
                print(f"تم حفظ تقرير JSON: {json_path}")
            
            # فحص ما إذا كان يجب فشل البرنامج
            if args.fail_on_issues:
                severity_levels = {'low': 1, 'medium': 2, 'high': 3}
                threshold = severity_levels[args.severity_threshold]
                
                critical_issues = []
                for issues in all_issues.values():
                    for issue in issues:
                        if severity_levels[issue.severity] >= threshold:
                            critical_issues.append(issue)
                
                if critical_issues:
                    print(f"فشل: تم العثور على {len(critical_issues)} مشكلة بخطورة {args.severity_threshold} أو أعلى")
                    sys.exit(1)
        else:
            print("✅ جميع ملفات التوجيه متوافقة!")
    
    print("اكتمل الفحص بنجاح")


if __name__ == "__main__":
    main()