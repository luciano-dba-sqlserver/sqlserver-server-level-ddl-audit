
# 🔍 Auditoria DDL em Nível de Servidor – SQL Server

Projeto de auditoria desenvolvido em SQL Server para capturar **eventos DDL em nível de servidor**, como criação, alteração e exclusão de bancos e objetos.

O objetivo é demonstrar **conhecimento prático em administração, segurança e auditoria**, seguindo boas práticas utilizadas em ambientes corporativos.

---

## 📌 Objetivo do Projeto

Registrar automaticamente comandos DDL executados no servidor, fornecendo rastreabilidade completa para fins de:

- Auditoria
- Compliance
- Troubleshooting
- Governança de banco de dados

---

## ⚙️ Funcionalidades

✔ Auditoria global em nível de servidor  
✔ Captura de eventos CREATE, ALTER e DROP  
✔ Registro de data/hora precisa (`datetime2`)  
✔ Identificação de login, usuário, banco e host  
✔ Registro completo do comando T-SQL executado  
✔ Execução segura via `EXECUTE AS`  
✔ Filtro de contas de serviço  
✔ Estrutura preparada para alertas e relatórios  

---

## 🛠️ Tecnologias Utilizadas

- Microsoft SQL Server
- DDL Triggers (Server Level)
- EVENTDATA() em XML
- Segurança e Contexto de Execução
- T-SQL Avançado

---

## 🧪 Validação (Hands On)

O projeto inclui um **hands-on prático**, onde:

1. Um login de teste é criado
2. O login executa comandos DDL
3. Os eventos são automaticamente registrados na tabela de auditoria
4. O contexto é revertido após o teste

Isso garante que o código foi **testado e validado**, não apenas documentado.

---

## 📈 Próximos Passos (Evolução)

- Envio de alertas por e-mail (Database Mail)
- Job para análise de comandos críticos
- Dashboard de auditoria
- Integração com políticas de compliance (LGPD / SOX)
- Retenção automática de dados históricos

---

## 👤 Autor

**Luciano Silva**  
DBA | SQL Server | Administração, Auditoria e Performance
