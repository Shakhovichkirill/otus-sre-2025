#!/bin/bash

echo "=== DIRECT COLLECTOR TEST ==="

# Создаем тестовый trace в формате OTLP
TEST_TRACE_JSON='{
  "resourceSpans": [
    {
      "resource": {
        "attributes": [
          {
            "key": "service.name",
            "value": { "stringValue": "direct-test" }
          }
        ]
      },
      "scopeSpans": [
        {
          "spans": [
            {
              "traceId": "1234567890abcdef1234567890abcdef",
              "spanId": "1234567890abcdef",
              "name": "direct.span.test",
              "startTimeUnixNano": '"$(date +%s)000000000"',
              "endTimeUnixNano": '"$(($(date +%s) + 1))000000000"',
              "attributes": [
                {
                  "key": "test.type",
                  "value": { "stringValue": "direct-http" }
                }
              ]
            }
          ]
        }
      ]
    }
  ]
}'

echo "Sending test trace directly to Collector..."
RESPONSE=$(curl -s -X POST http://localhost:4318/v1/traces \
  -H "Content-Type: application/json" \
  -d "$TEST_TRACE_JSON")

echo "Response: $RESPONSE"

# Проверяем логи Collector после отправки
echo -e "\nCollector logs after direct test:"
docker logs otel-collector --tail 5

echo -e "\n=== DIRECT TEST COMPLETE ==="
