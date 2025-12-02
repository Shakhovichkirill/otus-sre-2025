# HW17

Закрепить понимание алгоритмов распределения нагрузки
Обучиться работе с Jupyter для визуализации и симуляции процессов

Склонируйте репозиторий https://github.com/jolynch/performance-analysis
Запустите симуляцию очередей https://github.com/jolynch/performance-analysis/blob/master/notebooks/queueing_theory/queueing_analysis.ipynb
Запустите симуляцию Load Balancer https://github.com/jolynch/performance-analysis/blob/master/notebooks/queueing_theory/load_balancing_analysis.ipynb



# Выполнено

Запущены эмуляциии - скриншоты запуска эмуляции представлены в репозитории

Какая очередь наиболее эффективна по 95 перцентилю? - Single Queue, исходя из полученных данных эмуляции такая очередь наиболее эффективна по перцентилю 95, потому что имеет наименьшую задержку. 

Какие настройки LB имеют наименьший latency по 95 перцентилю? - Настройка LB weighted-choice-8 обеспечивает минимальный latency на 95-м процентиле

