from netmiko import ConnectHandler

# Caminho do arquivo com IPs
CAMINHO_IPS = "C:\Run\sw.txt"

# Credenciais iguais para todos os switches
credenciais = {
    'device_type': 'cisco_ios',
    'username': 'camila',
    'password': '12345',
}

# MAC Address que você quer encontrar
mac_input = "00:1A:2B:3C:4D:5E"

# Formata o MAC para padrão Cisco: xxxx.xxxx.xxxx
def formatar_mac(mac):
    mac = mac.lower().replace(":", "").replace("-", "").replace(".", "")
    return f"{mac[0:4]}.{mac[4:8]}.{mac[8:12]}"

mac_formatado = formatar_mac(mac_input)
print(f"\n🔍 Buscando MAC {mac_formatado}...\n")

# Carrega IPs do arquivo .txt
with open(CAMINHO_IPS, "r") as f:
    ips = [linha.strip() for linha in f if linha.strip()]

# Loop nos switches
for ip in ips:
    dispositivo = {**credenciais, 'ip': ip}
    print(f"Conectando ao switch {ip}...")

    try:
        conn = ConnectHandler(**dispositivo)
        output = conn.send_command("show mac address-table")

        if mac_formatado in output:
            print(f"✅ MAC {mac_formatado} encontrado no switch {ip}")
            for linha in output.splitlines():
                if mac_formatado in linha:
                    print(f" ↳ {linha.strip()}")
        else:
            print(f"❌ MAC não encontrado no switch {ip}.")

        conn.disconnect()

    except Exception as erro:
        print(f"🚫 Erro ao conectar no switch {ip}: {erro}")
