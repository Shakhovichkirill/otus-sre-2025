<?php
require_once('wp-load.php');

echo "<h1>OpenTelemetry Debug</h1>";

// Проверка расширения
if (extension_loaded('opentelemetry')) {
    echo "✅ OpenTelemetry extension: LOADED<br>";
    
    // Проверка функций
    $functions = [
        'opentelemetry_trace_start',
        'opentelemetry_trace_set_attribute',
        'opentelemetry_trace_end'
    ];
    
    foreach ($functions as $func) {
        echo function_exists($func) ? "✅ $func: EXISTS<br>" : "❌ $func: NOT FOUND<br>";
    }
    
    // Тестовый трейс
    if (function_exists('opentelemetry_trace_start')) {
        $span = opentelemetry_trace_start('debug.test');
        opentelemetry_trace_set_attribute($span, 'debug.message', 'Test from WordPress');
        opentelemetry_trace_set_attribute($span, 'debug.timestamp', date('c'));
        opentelemetry_trace_set_attribute($span, 'debug.url', home_url());
        opentelemetry_trace_end($span);
        
        echo "✅ Test trace created!<br>";
    }
    
} else {
    echo "❌ OpenTelemetry extension: NOT LOADED<br>";
}

// Проверка mu-plugins
echo "<h2>MU Plugins</h2>";
$mu_plugins = get_mu_plugins();
if (!empty($mu_plugins)) {
    foreach ($mu_plugins as $plugin => $info) {
        echo "✅ " . $info['Name'] . "<br>";
    }
} else {
    echo "❌ No MU plugins found<br>";
}

// Проверка окружения
echo "<h2>Environment</h2>";
echo "PHP Version: " . PHP_VERSION . "<br>";
echo "WordPress Version: " . get_bloginfo('version') . "<br>";
echo "OpenTelemetry Endpoint: " . ($_SERVER['OTEL_EXPORTER_OTLP_ENDPOINT'] ?? 'Not set') . "<br>";
