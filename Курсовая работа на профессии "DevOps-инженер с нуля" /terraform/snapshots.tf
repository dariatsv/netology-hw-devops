resource "yandex_compute_snapshot_schedule" "snapshot-disk" {
  name = "snapshot-dist"

  schedule_policy {
    expression = "0 0 * * *"
  }

  snapshot_count = 7

  disk_ids = [
    yandex_compute_instance.vm-nginx-1.boot_disk.0.disk_id,
    yandex_compute_instance.vm-nginx-2.boot_disk.0.disk_id,
    yandex_compute_instance.vm-bastion.boot_disk.0.disk_id,
    yandex_compute_instance.vm-prometheus.boot_disk.0.disk_id,
    yandex_compute_instance.vm-grafana.boot_disk.0.disk_id,
    yandex_compute_instance.vm-elasticsearch.boot_disk.0.disk_id,
    yandex_compute_instance.vm-kibana.boot_disk.0.disk_id]

  depends_on = [
    yandex_alb_load_balancer.alb]
}
