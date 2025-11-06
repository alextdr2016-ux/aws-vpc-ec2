# AWS VPC + EC2 with Terraform (Step‑by‑Step)

> Proiect didactic: creezi un VPC cu un subnet public, Internet Gateway, route table, Security Group, Key Pair și o instanță EC2 (Amazon Linux 2023) cu `user_data` care pornește Apache. Scris pas cu pas pentru începători.

---

## 0) Prerechizite

- **Cont AWS** activ și credențiale configurate local (`aws configure`) sau profil dedicat.
- **Terraform** ≥ 1.6 instalat.
- **OpenSSH** disponibil (Windows 10/11 are implicit) pentru generarea cheii.
- Region folosită în tutorial: **`eu-north-1`** (poți schimba în `variables.tf`).

## 1) Structura fișierelor

```
aws-vpc-ec2/
├─ providers.tf
├─ variables.tf
├─ vpc.tf
├─ igw.tf
├─ public-subnet.tf
├─ routes.tf
├─ security-group.tf
├─ keypair.tf
├─ ec2.tf
└─ outputs.tf
```

## 2) Ce face fiecare fișier (pe scurt)

- **providers.tf** – declară versiunea Terraform/Provider și `provider "aws"` (regiune, profil etc.).
- **variables.tf** – toate variabilele (ex: `aws_region`, `project_name`, `vpc_cidr`, `public_subnet_cidr`, `my_ip_cidr`, `public_key_path`, `instance_type`).
- **vpc.tf** – creează VPC (`aws_vpc`).
- **igw.tf** – creează Internet Gateway (`aws_internet_gateway`).
- **public-subnet.tf** – creează subnet public (`aws_subnet`, cu `map_public_ip_on_launch = true`).
- **routes.tf** – route table, ruta `0.0.0.0/0` (și opțional `::/0`) spre IGW, asocierea cu subnetul.
- **security-group.tf** – reguli inbound (SSH din IP-ul tău, HTTP/HTTPS din Internet), outbound allow‑all.
- **keypair.tf** – înregistrează în AWS cheia ta **publică** locală (nu generează chei!).
- **ec2.tf** – alege AMI AL2023 cu `data "aws_ami"`, lansează EC2 în subnetul public, atașează SG + Key Pair, `user_data` pentru Apache.
- **outputs.tf** – afișează `public_ip`, `instance_id` etc.

## 3) Variabile recomandate (exemple)

- `aws_region` = "eu-north-1"
- `project_name` = "vpc-ec2-demo"
- `vpc_cidr` = "10.0.0.0/16"
- `public_subnet_cidr` = "10.0.1.0/24"
- `my_ip_cidr` = "81.XXX.XXX.XXX/32" (IP-ul tău public)
- `public_key_path` = `C:/Users/<user>/.ssh/id_ed25519.pub`
- `instance_type` = "t3.micro"

> **Notă:** nu comita niciodată cheile private în Git. Folosește `.gitignore`.

## 4) Pași de rulare

1. **Inițializează Terraform**:

   ```bash
   terraform init
   ```

2. **Formatează & validează**:

   ```bash
   terraform fmt
   terraform validate
   ```

3. **Plan** (exemplu cu variabila pentru cheia publică):

   ```bash
   terraform plan -out=tf-plan -var "public_key_path=C:/Users/<user>/.ssh/id_ed25519.pub"
   ```

4. **Apply**:

   ```bash
   terraform apply "tf-plan"
   ```

5. **Outputs** (IP public):

   ```bash
   terraform output ec2_public_ip
   ```

6. **Conectare SSH** (Amazon Linux 2023):

   ```powershell
   ssh -i C:\Users\<user>\.ssh\id_ed25519 ec2-user@<EC2_PUBLIC_IP>
   ```

7. **Test web** (dacă ai `user_data` pentru Apache): deschide în browser `http://<EC2_PUBLIC_IP>`.

## 5) Comenzi utile

- **Afișează resurse din state**: `terraform state list`
- **Afișează detalii resursă**: `terraform state show <addr>`
- **Șterge infrastructura**: `terraform destroy`
- **Re-creează doar EC2** (după schimbări): `terraform taint/untaint` (rareori necesar) + `apply`.

## 6) Troubleshooting rapid

- **`Saved plan is stale`** – refă `plan` și rulează `apply` fără fișier vechi: `terraform plan && terraform apply`.
- **`RouteAlreadyExists`** – nu amesteca rute inline cu `aws_route`. Curăță state-ul sau importă resursa existentă.
- **`association ... timeout`** – verifică în consolă dacă asocierea există; dacă da, import‑o sau fă `state rm` + `apply`.
- **Nu pot face SSH** – verifică: SG (ingress 22 din IP-ul tău), key pair corect, user `ec2-user`, IP public valid, ruta 0.0.0.0/0 spre IGW.

## 7) Curățare (Destroy)

Când ai terminat și nu mai ai nevoie de resurse:

```bash
terraform destroy
```

> Confirmă promptul. Verifică în AWS Console că nu a rămas nimic activ (costuri!).

## 8) Linkuri oficiale (unde citești corect)

- **AWS EC2 – concepte**: [https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/concepts.html](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/concepts.html)
- **AWS – conectare SSH la Linux**: [https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/AccessingInstancesLinux.html](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/AccessingInstancesLinux.html)
- **AWS – Amazon Linux 2023**: [https://docs.aws.amazon.com/linux/al2023/ug/what-is-amazon-linux.html](https://docs.aws.amazon.com/linux/al2023/ug/what-is-amazon-linux.html)
- **Terraform – `aws_instance`**: [https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance)
- **Terraform – `aws_ami` (data source)**: [https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami)
- **Terraform – `aws_vpc`**: [https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc)
- **Terraform – `aws_internet_gateway`**: [https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway)
- **Terraform – `aws_subnet`**: [https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet)
- **Terraform – `aws_route_table`**: [https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table)
- **Terraform – `aws_route`**: [https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route)
- **Terraform – `aws_security_group`**: [https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group)
- **Terraform – `aws_key_pair`**: [https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair)

## 9) .gitignore recomandat

```gitignore
# Terraform
.terraform/
*.tfstate
*.tfstate.backup
*.tfvars
crash.log

# Chei / certs
*.pem
*.ppk
id_rsa
id_rsa.pub
id_ed25519
id_ed25519.pub
```

---

## 10) Rezumat „de pe teren”

1. Scrii fișierele .tf în ordinea: provider/variables → vpc → igw → subnet → routes → sg → keypair → ec2 → outputs.
2. Rulezi: `init` → `fmt` → `validate` → `plan` → `apply`.
3. Testezi: `terraform output` → SSH → browser.
4. Când termini: `terraform destroy`.

> Sfat: aplică incremental. După fiecare fișier nou, fă `fmt/validate/plan/apply` ca să izolezi ușor erorile.
