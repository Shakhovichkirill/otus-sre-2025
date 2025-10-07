def main():
    try:
        print("=== JSON COMPARISON ===")
        print("Items received:", len(items))
        
        if len(items) < 2:
            return [{
                'json': {
                    'status': 'ERROR',
                    'message': f'Need 2 nodes connected. Got: {len(items)}',
                    'icon': '⚠️'
                }
            }]
        
        data1 = items[0]['json']
        data2 = items[1]['json']
        
        print("Data1 year:", data1.get('year'))
        print("Data2 year:", data2.get('year'))
        
        differences = []
        
        if data1.get('year') != data2.get('year'):
            differences.append(f"Year: {data1.get('year')} != {data2.get('year')}")
        
        months1 = data1.get('months', [])
        months2 = data2.get('months', [])
        
        if len(months1) != len(months2):
            differences.append(f"Months count: {len(months1)} != {len(months2)}")
        else:
            for i in range(len(months1)):
                if months1[i].get('days') != months2[i].get('days'):
                    differences.append(f"Month {i+1} days differ")
        
        stats1 = data1.get('statistic', {})
        stats2 = data2.get('statistic', {})
        
        for key in ['workdays', 'holidays', 'hours40', 'hours36', 'hours24']:
            if stats1.get(key) != stats2.get(key):
                differences.append(f"Statistic.{key}: {stats1.get(key)} != {stats2.get(key)}")
        
        if not differences:
            result = {
                'status': 'IDENTICAL',
                'message': '✅ Data is identical!',
                'icon': '✅',
                'color': 'green'
            }
        else:
            result = {
                'status': 'DIFFERENT',
                'message': f'❌ Found {len(differences)} differences',
                'icon': '❌',
                'color': 'red',
                'differences_count': len(differences),
                'differences': differences
            }
        
        return [{'json': result}]
        
    except Exception as e:
        return [{
            'json': {
                'status': 'ERROR',
                'message': str(e),
                'icon': '⚠️'
            }
        }]

return main()
