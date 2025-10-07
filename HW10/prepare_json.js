// JavaScript нода для парсинга CSV
const response = $input.first().json;
const csvText = response.data;

// Разбиваем на строки
const lines = csvText.split('\n');

// Функция для парсинга CSV с учетом кавычек
function parseCSVLine(line) {
    const result = [];
    let current = '';
    let inQuotes = false;
    
    for (let i = 0; i < line.length; i++) {
        const char = line[i];
        
        if (char === '"') {
            if (inQuotes && line[i + 1] === '"') {
                current += '"';
                i++;
            } else {
                inQuotes = !inQuotes;
            }
        } else if (char === ',' && !inQuotes) {
            result.push(current);
            current = '';
        } else {
            current += char;
        }
    }
    
    result.push(current);
    return result;
}

// Парсим данные
const header = parseCSVLine(lines[0]);
const data = parseCSVLine(lines[1]);

console.log('Parsed data:', data);

return [{
    json: {
        parsed_data: data,
        status: 'parsed'
    }
}];
