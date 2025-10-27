# Найти путь пакета через систему

```
mount -t debugfs none /sys/kernel/debug
```
debugfs - специальная файловая система для отладки ядра. Монтируется в /sys/kernel/debug/ для доступа к отладочной информации ядра. 

```
mount | grep debugfs
debugfs on /sys/kernel/debug type debugfs (rw,nosuid,nodev,noexec,relatime)
```


Запуск Docker контейнера cilium/pwru, а также запуск pwru с фильтром трассировки. Pwru 
```
sudo docker run --privileged --rm -t --pid=host -v /sys/kernel/debug/:/sys/kernel/debug/ cilium/pwru pwru --output-tuple 'host 8.8.8.8'
```
Далее pwru готово к трассировки, ожидает пакеты.

Выполнено:
```
2025/10/27 19:11:02 Attaching kprobes (via kprobe-multi)...
1646 / 1646 [------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------] 100.00% ? p/s2025/10/27 19:11:02 Attached (ignored 0)
2025/10/27 19:11:02 Listening for events..
SKB                CPU PROCESS          NETNS      MARK/x        IFACE       PROTO  MTU   LEN   TUPLE FUNC
0xff1487b747f5fe00 0   ping:2387        4026531840 0               0         0x0000 0     92    10.130.0.30:0->8.8.8.8:0(icmp) ip_options_build
0xff1487b747f5fe00 0   ping:2387        4026531840 0               0         0x0000 1500  92    10.130.0.30:0->8.8.8.8:0(icmp) __ip_local_out
0xff1487b747f5fe00 0   ping:2387        4026531840 0               0         0x0800 1500  92    10.130.0.30:0->8.8.8.8:0(icmp) nf_hook_slow
0xff1487b747f5fe00 0   ping:2387        4026531840 0               0         0x0800 1500  92    10.130.0.30:0->8.8.8.8:0(icmp) ip_output
0xff1487b747f5fe00 0   ping:2387        4026531840 0             eth0:2      0x0800 1500  92    10.130.0.30:0->8.8.8.8:0(icmp) nf_hook_slow
0xff1487b747f5fe00 0   ping:2387        4026531840 0             eth0:2      0x0800 1500  92    10.130.0.30:0->8.8.8.8:0(icmp) apparmor_ip_postroute
0xff1487b747f5fe00 0   ping:2387        4026531840 0             eth0:2      0x0800 1500  92    10.130.0.30:0->8.8.8.8:0(icmp) ip_finish_output
0xff1487b747f5fe00 0   ping:2387        4026531840 0             eth0:2      0x0800 1500  92    10.130.0.30:0->8.8.8.8:0(icmp) __ip_finish_output
0xff1487b747f5fe00 0   ping:2387        4026531840 0             eth0:2      0x0800 1500  92    10.130.0.30:0->8.8.8.8:0(icmp) ip_finish_output2
0xff1487b747f5fe00 0   ping:2387        4026531840 0             eth0:2      0x0800 1500  106   10.130.0.30:0->8.8.8.8:0(icmp) __dev_queue_xmit
0xff1487b747f5fe00 0   ping:2387        4026531840 0             eth0:2      0x0800 1500  106   10.130.0.30:0->8.8.8.8:0(icmp) qdisc_pkt_len_init
0xff1487b747f5fe00 0   ping:2387        4026531840 0             eth0:2      0x0800 1500  106   10.130.0.30:0->8.8.8.8:0(icmp) netdev_core_pick_tx
0xff1487b747f5fe00 0   ping:2387        4026531840 0             eth0:2      0x0800 1500  106   10.130.0.30:0->8.8.8.8:0(icmp) netdev_pick_tx
0xff1487b747f5fe00 0   ping:2387        4026531840 0             eth0:2      0x0800 1500  106   10.130.0.30:0->8.8.8.8:0(icmp) __get_xps_queue_idx
0xff1487b747f5fe00 0   ping:2387        4026531840 0             eth0:2      0x0800 1500  106   10.130.0.30:0->8.8.8.8:0(icmp) sch_direct_xmit
0xff1487b747f5fe00 0   ping:2387        4026531840 0             eth0:2      0x0800 1500  106   10.130.0.30:0->8.8.8.8:0(icmp) validate_xmit_skb_list
0xff1487b747f5fe00 0   ping:2387        4026531840 0             eth0:2      0x0800 1500  106   10.130.0.30:0->8.8.8.8:0(icmp) validate_xmit_skb
```

Где:

```
--output-tuple   ---  вывод информации о сетевых кортежах (IP, порты)
```

```
host 8.8.8.8    --- фильтр трассировки только для пакетов, связанных с IP 8.8.8.8
```

Полный путь пакета был раздел на несколько этапов, опишем некоторые из них:

``` 
Подготовка IP пакета 
ip_options_build # Построение IP опций 
__ip_local_out   # Локальная отправка (исходящий) 
nf_hook_slow     # Netfilter hooks (OUTPUT цепочка)
ip_output        # Начало отправки IP пакета### Выполнено
```

```
Обработка на сетевом интерфейсе
nf_hook_slow              # Netfilter hooks (POSTROUTING)
apparmor_ip_postroute     # AppArmor проверка безопасности
ip_finish_output          # Завершение IP обработки
__ip_finish_output        # Финальная IP подготовка
ip_finish_output2         # Подготовка к передаче на L2
```

```
Передача на сетевую карту
__dev_queue_xmit          # Постановка в очередь устройства
qdisc_pkt_len_init        # Инициализация длины пакета
netdev_core_pick_tx       # Выбор TX очереди
netdev_pick_tx            # Выбор сетевого устройства
__get_xps_queue_idx       # Выбор конкретной очереди
sch_direct_xmit           # Прямая передача через qdisc
```

```
Валидация и отправка
validate_xmit_skb_list    # Проверка списка пакетов
validate_xmit_skb         # Валидация пакета
netif_skb_features        # Проверка возможностей сетевой карты
passthru_features_check   # Проверка функций passthrough
skb_network_protocol      # Определение сетевого протокола
validate_xmit_xfrm        # Проверка трансформаций (IPsec)
```

```
Передача
dev_hard_start_xmit       # Начало аппаратной передачи
start_xmit                # Запуск передачи драйвером
skb_clone_tx_timestamp    # Клонирование для временных меток
xmit_skb                  # Передача skb драйверу
skb_to_sgvec              # Преобразование в scatter-gather
__skb_to_sgvec            # Внутреннее преобразование
```
...

Трассировка пути сетевых пакетов через стек сетевых функций ядра Linux для адреса 8.8.8.8. Описание вывода трассировки.



# Отследить IO latency за 10 секунд

```
timeout 10 ./io_latency.bt
```
Инструмент для мониторинга задержек блочных устройств ввода-вывода (диски, SSD) с помощью bpftrace

```
dd if=/dev/zero of=/tmp/testfile bs=1M count=1000
```
Во время работы скрипта можно генерировать нагрузку


### Выполнено:

```
root@compute-vm-2-2-20-hdd-1761591544637:~# timeout 10 ./io_latency.bt
Attaching 5 probes...
Tracing block device I/O... Hit Ctrl-C to end.



@usecs:
[512, 1K)              1 |                                                    |
[1K, 2K)               2 |@                                                   |
[2K, 4K)               1 |                                                    |
[4K, 8K)               0 |                                                    |
[8K, 16K)              2 |@                                                   |
[16K, 32K)             1 |                                                    |
[32K, 64K)             5 |@@@                                                 |
[64K, 128K)            5 |@@@                                                 |
[128K, 256K)           9 |@@@@@@                                              |
[256K, 512K)           6 |@@@@                                                |
[512K, 1M)            70 |@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@|
[1M, 2M)              51 |@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@               |
[2M, 4M)               1 |                                                    |
```
