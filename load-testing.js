import http from 'k6/http';
import { check } from 'k6';
import { Rate } from 'k6/metrics';

// const SERVER_URL = 'http://localhost:4000/api/request';
const SERVER_URL = 'https://fly-health-check.fly.dev/api/request';

export const errorRate = new Rate('errors');

export const options = {
    discardResponseBodies: true,

    scenarios: {
        loadTesting: {
            executor: 'ramping-arrival-rate',
            startRate: 5,
            timeUnit: '1s',
            preAllocatedVUs: 10,
            stages: [
                { target: 25, duration: '1m' },
                { target: 25, duration: '1m' },
            ],
        },
    }
}

export default function() {
    check(http.get(SERVER_URL), {
        'status is 200': (r) => r.status == 200,
    }) || errorRate.add(1);
}

