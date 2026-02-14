# dotfiles
Meu setup i3 + Catppuccin + applets


#---- Alteração ----
## i3blocks (status bar)

Este setup substitui o i3status pelo i3blocks.

### 1. Instalar i3blocks

```bash
sudo apt install i3blocks
```

---

### 2. Alterar barra do i3

Editar:

```bash
nano ~/.config/i3/config
```

Dentro do bloco `bar { }`, usar:

```ini
status_command i3blocks -c ~/.config/i3blocks/config
```

---

### 3. Criar pasta do i3blocks

```bash
mkdir -p ~/.config/i3blocks
```

---

### 4. Arquivo principal do i3blocks

Criar:

```bash
nano ~/.config/i3blocks/config
```

Conteúdo:

```ini
[global]
separator=true
separator_block_width=12
markup=none

[cpu]
command=grep 'cpu ' /proc/stat | awk '{usage=($2+$4)*100/($2+$4+$5)} END {printf "CPU %.0f%%", usage}'
interval=5

[mem]
command=free -h | awk '/Mem:/ {print "RAM "$3 "/" $2}'
interval=5

[disk]
command=df -h / | awk 'NR==2 {print "DISK "$3 "/" $2}'
interval=30

[ip]
command=hostname -I | awk '{print "IP "$1}'
interval=10

[datetime]
command=date '+%d/%m %H:%M'
interval=1

[power]
command=/home/SEU_USUARIO/.config/i3blocks/power.sh
interval=once
separator=true
align=center
```

---

### 5. Script de power

Criar:

```bash
nano ~/.config/i3blocks/power.sh
```

Conteúdo:

```bash
#!/bin/bash
echo "  ⏻  "

case $BLOCK_BUTTON in
  1) i3-msg exit ;;
  2) reboot ;;
  3) shutdown now ;;
esac
```

Permissão:

```bash
chmod +x ~/.config/i3blocks/power.sh
```

---

### 6. Recarregar i3

```bash
i3-msg restart
```

---

### Resultado

Barra com:

CPU | RAM | DISK | IP | DATA/HORA | ⏻

Clique:
- Esquerdo → logout  
- Meio → reboot  
- Direito → shutdown  
