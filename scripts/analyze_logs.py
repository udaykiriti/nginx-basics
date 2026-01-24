import re
from collections import Counter, defaultdict
import sys
import statistics

# Configuration
LOG_FILE = sys.argv[1] if len(sys.argv) > 1 else 'logs/access.log'

# Regex to parse the custom log format
# Format: $remote_addr - $remote_user [$time_local] "$request" $status $body_bytes_sent "$http_referer" RT=$request_time URT=$upstream_response_time RID=$request_id CACHE=$upstream_cache_status ENV=$active_env
LOG_PATTERN = re.compile(
    r'(?P<ip>[\d\.]+) - (?P<user>.*) \[(?P<time>.*?) \] "(?P<request>.*?)" '
    r' (?P<status>\d{3}) (?P<bytes>\d+) ".*?" '
    r' RT=(?P<rt>[\d\.]+) URT=(?P<urt>[\d\.\-]+) RID=.*? CACHE=(?P<cache>.*?) ENV=(?P<env>.*)'
)

def analyze_logs():
    total_requests = 0
    ips = Counter()
    status_codes = Counter()
    envs = Counter()
    cache_statuses = Counter()
    response_times = []
    
    print(f"Analyzing log file: {LOG_FILE} ...\n")

    try:
        with open(LOG_FILE, 'r') as f:
            for line in f:
                match = LOG_PATTERN.match(line)
                if match:
                    total_requests += 1
                    data = match.groupdict()
                    
                    ips[data['ip']] += 1
                    status_codes[data['status']] += 1
                    envs[data['env']] += 1
                    cache_statuses[data['cache']] += 1
                    
                    try:
                        rt = float(data['rt'])
                        response_times.append(rt)
                    except ValueError:
                        pass
    except FileNotFoundError:
        print(f"Error: File '{LOG_FILE}' not found.")
        return

    if total_requests == 0:
        print("No requests found in log file.")
        return

    print("===  Nginx Traffic Analysis ===")
    print(f"Total Requests: {total_requests}")
    
    print("\n---  Traffic Distribution (Canary Test) ---")
    for env, count in envs.items():
        percentage = (count / total_requests) * 100
        print(f"  {env.upper()}: {count} ({percentage:.1f}%)")

    print("\n---  Performance ---")
    if response_times:
        avg_rt = statistics.mean(response_times)
        max_rt = max(response_times)
        print(f"  Average Response Time: {avg_rt:.4f}s")
        print(f"  Max Response Time:     {max_rt:.4f}s")

    print("\n---  Cache Efficiency ---")
    for status, count in cache_statuses.items():
        print(f"  {status}: {count}")

    print("\n---  Top 5 Clients ---")
    for ip, count in ips.most_common(5):
        print(f"  {ip}: {count} requests")

    print("\n---  Status Codes ---")
    for code, count in status_codes.items():
        print(f"  {code}: {count}")

if __name__ == "__main__":
    analyze_logs()
