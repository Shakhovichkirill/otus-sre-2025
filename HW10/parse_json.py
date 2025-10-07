def main():
    try:
        input_data = items[0]['json']
        data_values = input_data.get('parsed_data', [])
        
        result = {
            "year": 2022,
            "months": [{"month": i+1, "days": data_values[i+1]} for i in range(12)],
            "transitions": [
                {"from": "03.05", "to": "03.07"},
                {"from": "05.01", "to": "05.02"},
                {"from": "01.01", "to": "05.03"},
                {"from": "01.02", "to": "05.10"},
                {"from": "06.12", "to": "06.13"}
            ],
            "statistic": {
                "workdays": int(data_values[13]),
                "holidays": int(data_values[14]),
                "hours40": int(float(data_values[15])),
                "hours36": float(data_values[16]),
                "hours24": float(data_values[17])
            }
        }
        
        return [{'json': result}]
        
    except Exception as e:
        return [{'json': {'error': str(e), 'status': 'error'}}]

return main()
