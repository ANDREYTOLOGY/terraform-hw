# Домашнее задание занятию 11 `«Teamcity»` - `Чернышов Андрей`



Cкриншот autodetect конфигурации
![terraform 1](https://github.com/ANDREYTOLOGY/terraform-hw/blob/main/img/teamcity1.png)  
 
 Cкриншот первой сборки master  
![terraform 1](https://github.com/ANDREYTOLOGY/terraform-hw/blob/main/img/teamcity2.png)  

сборка по ветке master, то должен происходит mvn clean deploy, иначе mvn clean test
![terraform 1](https://github.com/ANDREYTOLOGY/terraform-hw/blob/main/img/teamcity3.png)  

скриншот консоли c тем же внешним ip-адресом  
![terraform 2](https://github.com/ANDREYTOLOGY/terraform-hw/blob/main/img/terraform2-2.png)  

```preemptible = true``` 
Полезно в обучении, потому что такие ВМ дешевле. Минус — их могут принудительно остановить/удалить.  

```core_fraction```
Параметр уменьшает гарантированную долю CPU и снижает стоимость ВМ — для учебных задач (поднять ВМ, подключиться по SSH, выполнить пару команд) это обычно достаточно.  

В моём случае на платформе standard-v3 значение core_fraction = 5 оказалось недоступно — Yandex Cloud разрешил только 20/50/100, поэтому выставлено 20. Аналогично на standard-v3 минимальное количество ядер оказалось 2, поэтому пришлось использовать cores = 2 (иначе API возвращал ошибку).  


### Задание 2

Проверка выполнена командой terraform plan  
![terraform 3](https://github.com/ANDREYTOLOGY/terraform-hw/blob/main/img/terraform2-3.png)  

В main.tf все ранее захардкоженные значения, для ресурсов yandex_compute_image и yandex_compute_instance заменены на переменные.

Исправленный фрагмент кода в main.tf:  
```terraform
data "yandex_compute_image" "ubuntu" {
   family = var.vm_web_image_family
}
resource "yandex_compute_instance" "platform" {
   name = var.vm_web_name
   platform_id = var.vm_web_platform_id

  resources {

    cores         = var.vm_web_cores
    memory        = var.vm_web_memory
    core_fraction = var.vm_web_core_fraction

  }
```

### Задание 3

Cкриншот ЛК Yandex Cloud с созданной ВМ db  
![terraform 1](https://github.com/ANDREYTOLOGY/terraform-hw/blob/main/img/terraform2-4.png)  

### Задание 4

Cкриншот вывода команды terraform output  
![terraform 1](https://github.com/ANDREYTOLOGY/terraform-hw/blob/main/img/terraform2-5.png)  

### Задание 5

В файле locals.tf создан один блок 
```locals {
  vm_web_full_name = "${var.vm_web_name}-${var.vm_web_platform_id}-${var.vm_web_cores}c"
  vm_db_full_name  = "${var.vm_db_name}-${var.vm_db_platform_id}-${var.vm_db_cores}c"
}
```
В нём определены локальные переменные имён ВМ с интерполяцией из нескольких переменных Terraform
![terraform 1](https://github.com/ANDREYTOLOGY/terraform-hw/blob/main/img/terraform2-6.png)  

### Задание 6

Вместо отдельных переменных *_cores, *_memory, *_core_fraction создана единая переменная vms_resources типа map(object), внутри которой заданы конфиги для обеих ВМ (web и db) в виде вложенных объектов.  
Также параметры диска (hdd_size, hdd_type) перенесены в тот же объект и используются в boot_disk.initialize_params.  
Создана общая переменная metadata типа map(string) и подключена в обеих ВМ как: metadata = var.metadata  
Все старые переменные vm_web_cores, vm_web_memory, vm_web_core_fraction, vm_db_cores, vm_db_memory, vm_db_core_fraction закомментированы, так как больше не используются.
