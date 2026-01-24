import threading
import requests
import time
import sys
import statistics

# Configuration
URL = "https://localhost:8443/api"
CONCURRENT_REQUESTS = 50
TOTAL_REQUESTS = 200

# Disable SSL warnings for self-signed certs
requests.packages.urllib3.disable_warnings()

def make_request(results):
    start_time = time.time()
    try:
        # Auth: admin/secret
        response = requests.get(URL, auth=('admin', 'secret'), verify=False, timeout=5)
        latency = time.time() - start_time
        results.append({
            'status': response.status_code,
            'latency': latency,
            'env': response.headers.get('X-Environment', 'unknown'),
            'cache': response.headers.get('X-Cache-Status', 'MISS')
        })
    except Exception as e:
        results.append({'status': 'error', 'latency': 0, 'error': str(e)})

def run_stress_test():
    print(f"🚀 Starting Stress Test: {TOTAL_REQUESTS} requests ({CONCURRENT_REQUESTS} concurrent)...")
    results = []
    threads = []

    start_total = time.time()

    # Launch threads in batches
    for i in range(0, TOTAL_REQUESTS, CONCURRENT_REQUESTS):
        batch = []
        for _ in range(CONCURRENT_REQUESTS):
            if len(results) + len(batch) + len(threads) < TOTAL_REQUESTS:
                t = threading.Thread(target=make_request, args=(results,))
                batch.append(t)
                t.start()
        
        for t in batch:
            t.join()
        print(f"   Batch completed: {min(i + CONCURRENT_REQUESTS, TOTAL_REQUESTS)}/{TOTAL_REQUESTS}")

    total_time = time.time() - start_total
    
    # Analysis
    success = [r for r in results if r['status'] == 200]
    latencies = [r['latency'] for r in success]
    
    print("\n=== 📊 Test Results ===")
    print(f"Total Time:      {total_time:.2f}s")
    print(f"Requests/Sec:    {len(success) / total_time:.2f}")
    print(f"Success Rate:    {len(success)}/{TOTAL_REQUESTS} ({len(success)/TOTAL_REQUESTS*100:.1f}%)")
    
    if latencies:
        print(f"Avg Latency:     {statistics.mean(latencies):.4f}s")
        print(f"P95 Latency:     {sorted(latencies)[int(len(latencies)*0.95)]:.4f}s")
    
    # Cache Stats
    cache_hits = len([r for r in success if r['cache'] == 'HIT'])
    print(f"Cache Hit Rate:  {cache_hits}/{len(success)} ({cache_hits/len(success)*100:.1f}%)")

if __name__ == "__main__":
    run_stress_test()
