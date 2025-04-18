

resource "azurerm_resource_group" "Rg" {
  name     = "${var.resource_group_name}-rg"
  location = var.location
}

resource "azurerm_virtual_network" "Vnet" {
  name                = "${var.virtual_network_name}-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.Rg.location
  resource_group_name = azurerm_resource_group.Rg.name
}

resource "azurerm_subnet" "Subnet" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.Rg.name
  virtual_network_name = azurerm_virtual_network.Vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_interface" "nic" {
  name                = "${var.nic_name}-nic"
  location            = azurerm_resource_group.Rg.location
  resource_group_name = azurerm_resource_group.Rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.Subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public_ip.id
  }
}
resource "azurerm_network_security_group" "nsg" {
  name                = "Staging-nsg"
  location            = azurerm_resource_group.Rg.location
  resource_group_name = azurerm_resource_group.Rg.name

  security_rule {
    name                       = "test-nsg"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = "Staging"
  }
}
resource "azurerm_network_interface_security_group_association" "nsg_nic" {
  network_interface_id      = azurerm_network_interface.nic.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

resource "azurerm_public_ip" "public_ip" {
  name                    = "${var.public_ip_name}-pip"
  location                = azurerm_resource_group.Rg.location
  resource_group_name     = azurerm_resource_group.Rg.name
  allocation_method       = "Static"
  idle_timeout_in_minutes = 30

  tags = {
    environment = "test"
  }
}


resource "azurerm_linux_virtual_machine" "Linux_VM" {
  name                = "${var.linux_VM_name}-machine"
  resource_group_name = azurerm_resource_group.Rg.name
  location            = azurerm_resource_group.Rg.location
  size                = "Standard_B1s"
  admin_username      = var.admin_username
  network_interface_ids = [
    azurerm_network_interface.nic.id,
  ]


  admin_ssh_key {
    username   = var.admin_username
    public_key = file(var.ssh_public_key_path)
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}

output "public_ip" {
  value       = azurerm_public_ip.public_ip.ip_address
  description = "This is the public ip of the virtual machine"
}