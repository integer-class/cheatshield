# timer.py
import time
from contextlib import contextmanager
from collections import defaultdict

class PerformanceTimer:
    def __init__(self):
        self.timers = defaultdict(list)
        
    @contextmanager
    def timer(self, name):
        """Context manager to time a block of code"""
        start = time.perf_counter()
        yield
        elapsed = time.perf_counter() - start
        self.timers[name].append(elapsed)
    
    def get_stats(self):
        """Calculate statistics for all timers"""
        stats = {}
        for name, times in self.timers.items():
            if times:
                stats[name] = {
                    'total': sum(times),
                    'avg': sum(times) / len(times),
                    'min': min(times),
                    'max': max(times),
                    'count': len(times)
                }
        return stats