#Root, KNSH
r = Ipnet.create(:id => 1, :name => "root", :created_at => Time.now, :updated_at => Time.now, :ipaddr =>"0.0.0.0", :netmask => "0.0.0.0", :lock_version =>"", :unq => "", :lvl => "0", :description => "Root-Netz")
r.root

i = Ipnet.create(:id => 2, :name => "KNSH", :created_at => Time.now, :updated_at => Time.now, :ipaddr =>"10.0.0.0", :netmask => "255.0.0.0", :lock_version =>"", :unq => "", :lvl => "1", :description => "KNSH")
i.move_to_child_of(1)

#VPNs

#01--------------
i = Ipnet.create(:id => 3, :name => "VPN_01_Landesbehörden_01", :created_at => Time.now, :updated_at => Time.now, :ipaddr => "10.245.0.0", :netmask => "255.255.240.0", :lock_version =>"", :unq => "", :lvl => "2", :description => "VPN 1")
i.move_to_child_of(2)

#VPN1 - 00017
#WAN
i = Ipnet.create(:id => 4, :name => "ZGR_00017_VPN01_WAN", :created_at => Time.now, :updated_at => Time.now, :ipaddr => "10.245.0.48", :netmask => "255.255.255.252", :lock_version =>"", :unq => "", :lvl => "3", :description => "Netz")
i.move_to_child_of(3)
i = Ipnet.create(:id => 5, :name => "ZGR_00017_INT_00_WAN_POP", :created_at => Time.now, :updated_at => Time.now, :ipaddr => "10.245.0.49", :netmask => "255.255.255.252", :lock_version =>"", :unq => "", :lvl => "4", :description => "WAN-POP")
i.move_to_child_of(3)
i = Ipnet.create(:id => 6, :name => "ZGR_00017_INT_00_WAN_ZGR", :created_at => Time.now, :updated_at => Time.now, :ipaddr => "10.245.0.50", :netmask => "255.255.255.252", :lock_version =>"", :unq => "", :lvl => "4", :description => "WAN-ZGR")
i.move_to_child_of(3)
#LAN
i = Ipnet.create(:id => 7, :name => "ZGR_00017_VPN01_LAN", :created_at => Time.now, :updated_at => Time.now, :ipaddr => "10.245.0.52", :netmask => "255.255.255.252", :lock_version =>"", :unq => "", :lvl => "3", :description => "Netz")
i.move_to_child_of(3)
i = Ipnet.create(:id => 8, :name => "ZGR_00017_INT_00", :created_at => Time.now, :updated_at => Time.now, :ipaddr => "10.245.0.53", :netmask => "255.255.255.252", :lock_version =>"", :unq => "", :lvl => "4", :description => "LAN-ZGR")
i.move_to_child_of(3)
i = Ipnet.create(:id => 9, :name => "ZGR_00017_INT_00_GW", :created_at => Time.now, :updated_at => Time.now, :ipaddr => "10.245.0.54", :netmask => "255.255.255.252", :lock_version =>"", :unq => "", :lvl => "4", :description => "LAN-ÜGR")
i.move_to_child_of(3)


#VPN1 - 00020
i = Ipnet.create(:id => 10, :name => "ZGR_00020_VPN01_WAN_01", :created_at => Time.now, :updated_at => Time.now, :ipaddr => "10.245.0.112", :netmask => "255.255.255.252", :lock_version =>"", :unq => "", :lvl => "3", :description => "Netz")
i.move_to_child_of(3)
i = Ipnet.create(:id => 11, :name => "ZGR_00020_VPN01_LAN_01", :created_at => Time.now, :updated_at => Time.now, :ipaddr => "10.245.0.116", :netmask => "255.255.255.252", :lock_version =>"", :unq => "", :lvl => "3", :description => "Netz")
i.move_to_child_of(3)
i = Ipnet.create(:id => 12, :name => "ZGR_00020_VPN01_WAN_02", :created_at => Time.now, :updated_at => Time.now, :ipaddr => "10.245.0.120", :netmask => "255.255.255.252", :lock_version =>"", :unq => "", :lvl => "3", :description => "Netz")
i.move_to_child_of(3)
i = Ipnet.create(:id => 13, :name => "ZGR_00020_VPN01_LAN_02", :created_at => Time.now, :updated_at => Time.now, :ipaddr => "10.245.0.124", :netmask => "255.255.255.252", :lock_version =>"", :unq => "", :lvl => "3", :description => "Netz")
i.move_to_child_of(3)

#WAN
i = Ipnet.create(:id => 14, :name => "ZGR_00020_INT_00_WAN_POP", :created_at => Time.now, :updated_at => Time.now, :ipaddr => "10.245.0.113", :netmask => "255.255.255.252", :lock_version =>"", :unq => "", :lvl => "4", :description => "WAN-POP")
i.move_to_child_of(3)
i = Ipnet.create(:id => 15, :name => "ZGR_00020_INT_00_WAN_ZGR", :created_at => Time.now, :updated_at => Time.now, :ipaddr => "10.245.0.114", :netmask => "255.255.255.252", :lock_version =>"", :unq => "", :lvl => "4", :description => "WAN-ZGR")
i.move_to_child_of(3)
#LAN
i = Ipnet.create(:id => 16, :name => "ZGR_00020_INT_00", :created_at => Time.now, :updated_at => Time.now, :ipaddr => "10.245.0.117", :netmask => "255.255.255.252", :lock_version =>"", :unq => "", :lvl => "4", :description => "LAN-ZGR")
i.move_to_child_of(3)
i = Ipnet.create(:id => 17, :name => "ZGR_00020_INT_00_GW", :created_at => Time.now, :updated_at => Time.now, :ipaddr => "10.245.0.118", :netmask => "255.255.255.252", :lock_version =>"", :unq => "", :lvl => "4", :description => "LAN-ÜGR")
i.move_to_child_of(3)

#WAN
i = Ipnet.create(:id => 18, :name => "ZGR_00020_INT_01_WAN_POP", :created_at => Time.now, :updated_at => Time.now, :ipaddr => "10.245.0.121", :netmask => "255.255.255.252", :lock_version =>"", :unq => "", :lvl => "4", :description => "WAN-POP")
i.move_to_child_of(3)
i = Ipnet.create(:id => 19, :name => "ZGR_00020_INT_01_WAN_ZGR", :created_at => Time.now, :updated_at => Time.now, :ipaddr => "10.245.0.122", :netmask => "255.255.255.252", :lock_version =>"", :unq => "", :lvl => "4", :description => "WAN-ZGR")
i.move_to_child_of(3)
#LAN
i = Ipnet.create(:id => 20, :name => "ZGR_00020_INT_01", :created_at => Time.now, :updated_at => Time.now, :ipaddr => "10.245.0.125", :netmask => "255.255.255.252", :lock_version =>"", :unq => "", :lvl => "4", :description => "LAN-ZGR")
i.move_to_child_of(3)
i = Ipnet.create(:id => 21, :name => "ZGR_00020_INT_01_GW", :created_at => Time.now, :updated_at => Time.now, :ipaddr => "10.245.0.126", :netmask => "255.255.255.252", :lock_version =>"", :unq => "", :lvl => "4", :description => "LAN-ÜGR")
i.move_to_child_of(3)


#VPN1 - 00256
#WAN
i = Ipnet.create(:id => 22, :name => "ZGR_00256_VPN01_WAN", :created_at => Time.now, :updated_at => Time.now, :ipaddr => "10.245.2.136", :netmask => "255.255.255.252", :lock_version =>"", :unq => "", :lvl => "3", :description => "Netz")
i.move_to_child_of(3)
i = Ipnet.create(:id => 23, :name => "ZGR_00256_INT_00_WAN_POP", :created_at => Time.now, :updated_at => Time.now, :ipaddr => "10.245.2.137", :netmask => "255.255.255.252", :lock_version =>"", :unq => "", :lvl => "4", :description => "WAN-POP")
i.move_to_child_of(3)
i = Ipnet.create(:id => 24, :name => "ZGR_00256_INT_00_WAN_ZGR", :created_at => Time.now, :updated_at => Time.now, :ipaddr => "10.245.2.138", :netmask => "255.255.255.252", :lock_version =>"", :unq => "", :lvl => "4", :description => "WAN-ZGR")
i.move_to_child_of(3)
#LAN
i = Ipnet.create(:id => 25, :name => "ZGR_00256_VPN01_LAN", :created_at => Time.now, :updated_at => Time.now, :ipaddr => "10.245.2.140", :netmask => "255.255.255.252", :lock_version =>"", :unq => "", :lvl => "3", :description => "Netz")
i.move_to_child_of(3)
i = Ipnet.create(:id => 25, :name => "ZGR_00256_INT_00", :created_at => Time.now, :updated_at => Time.now, :ipaddr => "10.245.2.141", :netmask => "255.255.255.252", :lock_version =>"", :unq => "", :lvl => "4", :description => "LAN-ZGR")
i.move_to_child_of(3)
i = Ipnet.create(:id => 26, :name => "ZGR_00256_INT_00_GW", :created_at => Time.now, :updated_at => Time.now, :ipaddr => "10.245.2.142", :netmask => "255.255.255.252", :lock_version =>"", :unq => "", :lvl => "4", :description => "LAN-ÜGR")
i.move_to_child_of(3)



#02--------------
i = Ipnet.create(:id => 27, :name => "VPN_02_Finanzverwaltung_01", :created_at => Time.now, :updated_at => Time.now, :ipaddr => "10.245.16.0", :netmask => "255.255.240.0", :lock_version =>"", :unq => "", :lvl => "2", :description => "VPN 2")
i.move_to_child_of(2)

#VPN2 - 00256
#WAN
i = Ipnet.create(:id => 28, :name => "ZGR_00256_VPN02_WAN", :created_at => Time.now, :updated_at => Time.now, :ipaddr => "10.245.31.248", :netmask => "255.255.255.252", :lock_version =>"", :unq => "", :lvl => "3", :description => "Netz")
i.move_to_child_of(4)
i = Ipnet.create(:id => 29, :name => "ZGR_00256_INT_01_WAN_POP", :created_at => Time.now, :updated_at => Time.now, :ipaddr => "10.245.31.249", :netmask => "255.255.255.252", :lock_version =>"", :unq => "", :lvl => "4", :description => "WAN-POP")
i.move_to_child_of(4)
i = Ipnet.create(:id => 30, :name => "ZGR_00256_INT_01_WAN_ZGR", :created_at => Time.now, :updated_at => Time.now, :ipaddr => "10.245.31.250", :netmask => "255.255.255.252", :lock_version =>"", :unq => "", :lvl => "4", :description => "WAN-ZGR")
i.move_to_child_of(4)
#LAN
i = Ipnet.create(:id => 31, :name => "ZGR_00256_VPN02_LAN", :created_at => Time.now, :updated_at => Time.now, :ipaddr => "10.245.31.252", :netmask => "255.255.255.252", :lock_version =>"", :unq => "", :lvl => "3", :description => "Netz")
i.move_to_child_of(4)
i = Ipnet.create(:id => 32, :name => "ZGR_00256_INT_01", :created_at => Time.now, :updated_at => Time.now, :ipaddr => "10.245.31.253", :netmask => "255.255.255.252", :lock_version =>"", :unq => "", :lvl => "4", :description => "LAN-ZGR")
i.move_to_child_of(4)
i = Ipnet.create(:id => 33, :name => "ZGR_00256_INT_01_GW", :created_at => Time.now, :updated_at => Time.now, :ipaddr => "10.245.31.254", :netmask => "255.255.255.252", :lock_version =>"", :unq => "", :lvl => "4", :description => "LAN-ÜGR")
i.move_to_child_of(4)


#03--------------
i = Ipnet.create(:id => 34, :name => "VPN_03_Justiz/Amtsgerichte_01", :created_at => Time.now, :updated_at => Time.now, :ipaddr => "10.245.32.0", :netmask => "255.255.240.0", :lock_version =>"", :unq => "", :lvl => "2", :description => "VPN 3")
i.move_to_child_of(2)

#VPN3 - 00256
#WAN
i = Ipnet.create(:id => 35, :name => "ZGR_00256_VPN03_WAN", :created_at => Time.now, :updated_at => Time.now, :ipaddr => "10.245.47.248", :netmask => "255.255.255.252", :lock_version =>"", :unq => "", :lvl => "3", :description => "Netz")
i.move_to_child_of(5)
i = Ipnet.create(:id => 36, :name => "ZGR_00256_INT_02_WAN_POP", :created_at => Time.now, :updated_at => Time.now, :ipaddr => "10.245.47.249", :netmask => "255.255.255.252", :lock_version =>"", :unq => "", :lvl => "4", :description => "WAN-POP")
i.move_to_child_of(5)
i = Ipnet.create(:id => 37, :name => "ZGR_00256_INT_02_WAN_ZGR", :created_at => Time.now, :updated_at => Time.now, :ipaddr => "10.245.47.250", :netmask => "255.255.255.252", :lock_version =>"", :unq => "", :lvl => "4", :description => "WAN-ZGR")
i.move_to_child_of(5)
#LAN
i = Ipnet.create(:id => 38, :name => "ZGR_00256_VPN03_LAN", :created_at => Time.now, :updated_at => Time.now, :ipaddr => "10.245.47.252", :netmask => "255.255.255.252", :lock_version =>"", :unq => "", :lvl => "3", :description => "Netz")
i.move_to_child_of(5)
i = Ipnet.create(:id => 39, :name => "ZGR_00256_INT_02", :created_at => Time.now, :updated_at => Time.now, :ipaddr => "10.245.47.253", :netmask => "255.255.255.252", :lock_version =>"", :unq => "", :lvl => "4", :description => "LAN-ZGR")
i.move_to_child_of(5)
i = Ipnet.create(:id => 40, :name => "ZGR_00256_INT_02_GW", :created_at => Time.now, :updated_at => Time.now, :ipaddr => "10.245.47.254", :netmask => "255.255.255.252", :lock_version =>"", :unq => "", :lvl => "4", :description => "LAN-ÜGR")
i.move_to_child_of(5)


#04--------------
i = Ipnet.create(:id => 41, :name => "VPN_04_Justiz/Staatsanwaltschaften_01", :created_at => Time.now, :updated_at => Time.now, :ipaddr => "10.245.48.0", :netmask => "255.255.240.0", :lock_version =>"", :unq => "", :lvl => "2", :description => "VPN 4")
i.move_to_child_of(2)

#VPN4 - 00256
#WAN
i = Ipnet.create(:id => 42, :name => "ZGR_00256_VPN04_WAN", :created_at => Time.now, :updated_at => Time.now, :ipaddr => "10.245.63.248", :netmask => "255.255.255.252", :lock_version =>"", :unq => "", :lvl => "3", :description => "Netz")
i.move_to_child_of(6)
i = Ipnet.create(:id => 43, :name => "ZGR_00256_INT_03_WAN_POP", :created_at => Time.now, :updated_at => Time.now, :ipaddr => "10.245.63.249", :netmask => "255.255.255.252", :lock_version =>"", :unq => "", :lvl => "4", :description => "WAN-POP")
i.move_to_child_of(6)
i = Ipnet.create(:id => 44, :name => "ZGR_00256_INT_03_WAN_ZGR", :created_at => Time.now, :updated_at => Time.now, :ipaddr => "10.245.63.250", :netmask => "255.255.255.252", :lock_version =>"", :unq => "", :lvl => "4", :description => "WAN-ZGR")
i.move_to_child_of(6)
#LAN
i = Ipnet.create(:id => 45, :name => "ZGR_00256_VPN04_LAN", :created_at => Time.now, :updated_at => Time.now, :ipaddr => "10.245.63.252", :netmask => "255.255.255.252", :lock_version =>"", :unq => "", :lvl => "3", :description => "Netz")
i.move_to_child_of(6)
i = Ipnet.create(:id => 46, :name => "ZGR_00256_INT_03", :created_at => Time.now, :updated_at => Time.now, :ipaddr => "10.245.63.253", :netmask => "255.255.255.252", :lock_version =>"", :unq => "", :lvl => "4", :description => "LAN-ZGR")
i.move_to_child_of(6)
i = Ipnet.create(:id => 47, :name => "ZGR_00256_INT_03_GW", :created_at => Time.now, :updated_at => Time.now, :ipaddr => "10.245.63.254", :netmask => "255.255.255.252", :lock_version =>"", :unq => "", :lvl => "4", :description => "LAN-ÜGR")
i.move_to_child_of(6)


#05--------------
i = Ipnet.create(:id => 48, :name => "VPN_05_Polizei/Vollzug_01", :created_at => Time.now, :updated_at => Time.now, :ipaddr => "10.245.64.0", :netmask => "255.255.240.0", :lock_version =>"", :unq => "", :lvl => "2", :description => "VPN 5")
i.move_to_child_of(2)

#VPN5 - 00004
#WAN
i = Ipnet.create(:id => 49, :name => "ZGR_00004_VPN05_WAN", :created_at => Time.now, :updated_at => Time.now, :ipaddr => "10.245.64.16", :netmask => "255.255.255.252", :lock_version =>"", :unq => "", :lvl => "3", :description => "Netz")
i.move_to_child_of(7)
i = Ipnet.create(:id => 50, :name => "ZGR_00004_INT_00_WAN_POP", :created_at => Time.now, :updated_at => Time.now, :ipaddr => "10.245.64.17", :netmask => "255.255.255.252", :lock_version =>"", :unq => "", :lvl => "4", :description => "WAN-POP")
i.move_to_child_of(7)
i = Ipnet.create(:id => 51, :name => "ZGR_00004_INT_00_WAN_ZGR", :created_at => Time.now, :updated_at => Time.now, :ipaddr => "10.245.64.18", :netmask => "255.255.255.252", :lock_version =>"", :unq => "", :lvl => "4", :description => "WAN-ZGR")
i.move_to_child_of(7)
#LAN
i = Ipnet.create(:id => 52, :name => "ZGR_00004_VPN05_LAN", :created_at => Time.now, :updated_at => Time.now, :ipaddr => "10.245.64.20", :netmask => "255.255.255.252", :lock_version =>"", :unq => "", :lvl => "3", :description => "Netz")
i.move_to_child_of(7)
i = Ipnet.create(:id => 53, :name => "ZGR_00004_INT_00", :created_at => Time.now, :updated_at => Time.now, :ipaddr => "10.245.64.21", :netmask => "255.255.255.252", :lock_version =>"", :unq => "", :lvl => "4", :description => "LAN-ZGR")
i.move_to_child_of(7)
i = Ipnet.create(:id => 54, :name => "ZGR_00004_INT_00_GW", :created_at => Time.now, :updated_at => Time.now, :ipaddr => "10.245.64.22", :netmask => "255.255.255.252", :lock_version =>"", :unq => "", :lvl => "4", :description => "LAN-ÜGR")
i.move_to_child_of(7)

#VPN5 - 00014
#WAN
i = Ipnet.create(:id => 55, :name => "ZGR_00014_VPN05_WAN", :created_at => Time.now, :updated_at => Time.now, :ipaddr => "10.245.71.136", :netmask => "255.255.255.252", :lock_version =>"", :unq => "", :lvl => "3", :description => "Netz")
i.move_to_child_of(7)
i = Ipnet.create(:id => 56, :name => "ZGR_00014_INT_02_WAN_POP", :created_at => Time.now, :updated_at => Time.now, :ipaddr => "10.245.71.137", :netmask => "255.255.255.252", :lock_version =>"", :unq => "", :lvl => "4", :description => "WAN-POP")
i.move_to_child_of(7)
i = Ipnet.create(:id => 57, :name => "ZGR_00014_INT_02_WAN_ZGR", :created_at => Time.now, :updated_at => Time.now, :ipaddr => "10.245.71.138", :netmask => "255.255.255.252", :lock_version =>"", :unq => "", :lvl => "4", :description => "WAN-ZGR")
i.move_to_child_of(7)
#LAN
i = Ipnet.create(:id => 58, :name => "ZGR_00014_VPN05_LAN", :created_at => Time.now, :updated_at => Time.now, :ipaddr => "10.245.71.140", :netmask => "255.255.255.252", :lock_version =>"", :unq => "", :lvl => "3", :description => "Netz")
i.move_to_child_of(7)
i = Ipnet.create(:id => 59, :name => "ZGR_00014_INT_02", :created_at => Time.now, :updated_at => Time.now, :ipaddr => "10.245.71.141", :netmask => "255.255.255.252", :lock_version =>"", :unq => "", :lvl => "4", :description => "LAN-ZGR")
i.move_to_child_of(7)
i = Ipnet.create(:id => 60, :name => "ZGR_00014_INT_02_GW", :created_at => Time.now, :updated_at => Time.now, :ipaddr => "10.245.71.142", :netmask => "255.255.255.252", :lock_version =>"", :unq => "", :lvl => "4", :description => "LAN-ÜGR")
i.move_to_child_of(7)

#VPN5 - 00005
#WAN
i = Ipnet.create(:id => 61, :name => "ZGR_00005_VPN05_WAN", :created_at => Time.now, :updated_at => Time.now, :ipaddr => "10.245.69.0", :netmask => "255.255.255.252", :lock_version =>"", :unq => "", :lvl => "3", :description => "Netz")
i.move_to_child_of(7)
i = Ipnet.create(:id => 62, :name => "ZGR_00005_INT_03_WAN_POP", :created_at => Time.now, :updated_at => Time.now, :ipaddr => "10.245.69.1", :netmask => "255.255.255.252", :lock_version =>"", :unq => "", :lvl => "4", :description => "WAN-POP")
i.move_to_child_of(7)
i = Ipnet.create(:id => 63, :name => "ZGR_00005_INT_03_WAN_ZGR", :created_at => Time.now, :updated_at => Time.now, :ipaddr => "10.245.69.2", :netmask => "255.255.255.252", :lock_version =>"", :unq => "", :lvl => "4", :description => "WAN-ZGR")
i.move_to_child_of(7)
#LAN
i = Ipnet.create(:id => 64, :name => "ZGR_00005_VPN05_LAN", :created_at => Time.now, :updated_at => Time.now, :ipaddr => "10.245.69.4", :netmask => "255.255.255.252", :lock_version =>"", :unq => "", :lvl => "3", :description => "Netz")
i.move_to_child_of(7)
i = Ipnet.create(:id => 65, :name => "ZGR_00005_INT_03", :created_at => Time.now, :updated_at => Time.now, :ipaddr => "10.245.69.5", :netmask => "255.255.255.252", :lock_version =>"", :unq => "", :lvl => "4", :description => "LAN-ZGR")
i.move_to_child_of(7)
i = Ipnet.create(:id => 66, :name => "ZGR_00005_INT_03_GW", :created_at => Time.now, :updated_at => Time.now, :ipaddr => "10.245.69.6", :netmask => "255.255.255.252", :lock_version =>"", :unq => "", :lvl => "4", :description => "LAN-ÜGR")
i.move_to_child_of(7)

#VPN5 - 00256
#WAN
i = Ipnet.create(:id => 67, :name => "ZGR_00256_VPN05_WAN", :created_at => Time.now, :updated_at => Time.now, :ipaddr => "10.245.79.248", :netmask => "255.255.255.252", :lock_version =>"", :unq => "", :lvl => "3", :description => "Netz")
i.move_to_child_of(7)
i = Ipnet.create(:id => 68, :name => "ZGR_00256_INT_04_WAN_POP", :created_at => Time.now, :updated_at => Time.now, :ipaddr => "10.245.79.249", :netmask => "255.255.255.252", :lock_version =>"", :unq => "", :lvl => "4", :description => "WAN-POP")
i.move_to_child_of(7)
i = Ipnet.create(:id => 69, :name => "ZGR_00256_INT_04_WAN_ZGR", :created_at => Time.now, :updated_at => Time.now, :ipaddr => "10.245.79.250", :netmask => "255.255.255.252", :lock_version =>"", :unq => "", :lvl => "4", :description => "WAN-ZGR")
i.move_to_child_of(7)
#LAN
i = Ipnet.create(:id => 70, :name => "ZGR_00256_VPN05_LAN", :created_at => Time.now, :updated_at => Time.now, :ipaddr => "10.245.79.252", :netmask => "255.255.255.252", :lock_version =>"", :unq => "", :lvl => "3", :description => "Netz")
i.move_to_child_of(7)
i = Ipnet.create(:id => 71, :name => "ZGR_00256_INT_04", :created_at => Time.now, :updated_at => Time.now, :ipaddr => "10.245.79.253", :netmask => "255.255.255.252", :lock_version =>"", :unq => "", :lvl => "4", :description => "LAN-ZGR")
i.move_to_child_of(7)
i = Ipnet.create(:id => 72, :name => "ZGR_00256_INT_04_GW", :created_at => Time.now, :updated_at => Time.now, :ipaddr => "10.245.79.254", :netmask => "255.255.255.252", :lock_version =>"", :unq => "", :lvl => "4", :description => "LAN-ÜGR")
i.move_to_child_of(7)


#06--------------
i = Ipnet.create(:id => 73, :name => "VPN_06_Sozialwesen_01", :created_at => Time.now, :updated_at => Time.now, :ipaddr => "10.245.80.0", :netmask => "255.255.240.0", :lock_version =>"", :unq => "", :lvl => "2", :description => "VPN 6")
i.move_to_child_of(2)

#VPN6 - 00004
#WAN
i = Ipnet.create(:id => 74, :name => "ZGR_00004_VPN06_WAN", :created_at => Time.now, :updated_at => Time.now, :ipaddr => "10.245.80.8", :netmask => "255.255.255.252", :lock_version =>"", :unq => "", :lvl => "3", :description => "Netz")
i.move_to_child_of(8)
i = Ipnet.create(:id => 75, :name => "ZGR_00004_INT_03_WAN_POP", :created_at => Time.now, :updated_at => Time.now, :ipaddr => "10.245.80.9", :netmask => "255.255.255.252",:lock_version =>"", :unq => "", :lvl => "4", :description => "WAN-POP")
i.move_to_child_of(8)
i = Ipnet.create(:id => 76, :name => "ZGR_00004_INT_03_WAN_ZGR", :created_at => Time.now, :updated_at => Time.now, :ipaddr => "10.245.80.10", :netmask => "255.255.255.252", :lock_version =>"", :unq => "", :lvl => "4", :description => "WAN-ZGR")
i.move_to_child_of(8)
#LAN
i = Ipnet.create(:id => 77, :name => "ZGR_00004_VPN06_LAN", :created_at => Time.now, :updated_at => Time.now, :ipaddr => "10.245.80.12", :netmask => "255.255.255.252", :lock_version =>"", :unq => "", :lvl => "3", :description => "Netz")
i.move_to_child_of(8)
i = Ipnet.create(:id => 78, :name => "ZGR_00004_INT_03", :created_at => Time.now, :updated_at => Time.now, :ipaddr => "10.245.80.13", :netmask => "255.255.255.252", :lock_version =>"", :unq => "", :lvl => "4", :description => "LAN-ZGR")
i.move_to_child_of(8)
i = Ipnet.create(:id => 79, :name => "ZGR_00004_INT_03_GW", :created_at => Time.now, :updated_at => Time.now, :ipaddr => "10.245.80.14", :netmask => "255.255.255.252", :lock_version =>"", :unq => "", :lvl => "4", :description => "LAN-ÜGR")
i.move_to_child_of(8)

#VPN6 - 00256
#WAN
i = Ipnet.create(:id => 80, :name => "ZGR_00256_VPN06_WAN", :created_at => Time.now, :updated_at => Time.now, :ipaddr => "10.245.80.0", :netmask => "255.255.255.252", :lock_version =>"", :unq => "", :lvl => "3", :description => "Netz")
i.move_to_child_of(8)
i = Ipnet.create(:id => 81, :name => "ZGR_00256_INT_13_WAN_POP", :created_at => Time.now, :updated_at => Time.now, :ipaddr => "10.245.80.1", :netmask => "255.255.255.252", :lock_version =>"", :unq => "", :lvl => "4", :description => "WAN-POP")
i.move_to_child_of(8)
i = Ipnet.create(:id => 82, :name => "ZGR_00256_INT_13_WAN_ZGR", :created_at => Time.now, :updated_at => Time.now, :ipaddr => "10.245.80.2", :netmask => "255.255.255.252", :lock_version =>"", :unq => "", :lvl => "4", :description => "WAN-ZGR")
i.move_to_child_of(8)
#LAN
i = Ipnet.create(:id => 83, :name => "ZGR_00256_VPN06_LAN", :created_at => Time.now, :updated_at => Time.now, :ipaddr => "10.245.80.4", :netmask => "255.255.255.252", :lock_version =>"", :unq => "", :lvl => "3", :description => "Netz")
i.move_to_child_of(8)
i = Ipnet.create(:id => 84, :name => "ZGR_00256_INT_13", :created_at => Time.now, :updated_at => Time.now, :ipaddr => "10.245.80.5", :netmask => "255.255.255.252", :lock_version =>"", :unq => "", :lvl => "4", :description => "LAN-ZGR")
i.move_to_child_of(8)
i = Ipnet.create(:id => 85, :name => "ZGR_00256_INT_13_GW", :created_at => Time.now, :updated_at => Time.now, :ipaddr => "10.245.80.6", :netmask => "255.255.255.252", :lock_version =>"", :unq => "", :lvl => "4", :description => "LAN-ÜGR")
i.move_to_child_of(8)


#17--------------
i = Ipnet.create(:id => 86, :name => "VPN_17_Voice_01", :created_at => Time.now, :updated_at => Time.now, :ipaddr => "10.246.0.0", :netmask => "255.255.240.0", :lock_version =>"", :unq => "", :lvl => "2", :description => "VPN 17")
i.move_to_child_of(2)

#VPN17 - 00004
#WAN
i = Ipnet.create(:id => 87, :name => "ZGR_00004_VPN17_WAN", :created_at => Time.now, :updated_at => Time.now, :ipaddr => "10.246.0.56", :netmask => "255.255.255.252", :lock_version =>"", :unq => "", :lvl => "3", :description => "Netz")
i.move_to_child_of(9)
i = Ipnet.create(:id => 88, :name => "ZGR_00004_INT_02_WAN_POP", :created_at => Time.now, :updated_at => Time.now, :ipaddr => "10.246.0.57", :netmask => "255.255.255.252", :lock_version =>"", :unq => "", :lvl => "4", :description => "WAN-POP")
i.move_to_child_of(9)
i = Ipnet.create(:id => 89, :name => "ZGR_00004_INT_02_WAN_ZGR", :created_at => Time.now, :updated_at => Time.now, :ipaddr => "10.246.0.58", :netmask => "255.255.255.252", :lock_version =>"", :unq => "", :lvl => "4", :description => "WAN-ZGR")
i.move_to_child_of(9)
#LAN
i = Ipnet.create(:id => 90, :name => "ZGR_00004_VPN17_LAN", :created_at => Time.now, :updated_at => Time.now, :ipaddr => "10.246.0.60", :netmask => "255.255.255.252", :lock_version =>"", :unq => "", :lvl => "3", :description => "Netz")
i.move_to_child_of(9)
i = Ipnet.create(:id => 91, :name => "ZGR_00004_INT_02", :created_at => Time.now, :updated_at => Time.now, :ipaddr => "10.246.0.61", :netmask => "255.255.255.252", :lock_version =>"", :unq => "", :lvl => "4", :description => "LAN-ZGR")
i.move_to_child_of(9)
i = Ipnet.create(:id => 92, :name => "ZGR_00004_INT_02_GW", :created_at => Time.now, :updated_at => Time.now, :ipaddr => "10.246.0.62", :netmask => "255.255.255.252", :lock_version =>"", :unq => "", :lvl => "4", :description => "LAN-ÜGR")
i.move_to_child_of(9)

#VPN17 - 00014
#WAN
i = Ipnet.create(:id => 93, :name => "ZGR_00014_VPN17_WAN", :created_at => Time.now, :updated_at => Time.now, :ipaddr => "10.246.0.96", :netmask => "255.255.255.252", :lock_version =>"", :unq => "", :lvl => "3", :description => "Netz")
i.move_to_child_of(9)
i = Ipnet.create(:id => 94, :name => "ZGR_00014_INT_01_WAN_POP", :created_at => Time.now, :updated_at => Time.now, :ipaddr => "10.246.0.97", :netmask => "255.255.255.252", :lock_version =>"", :unq => "", :lvl => "4", :description => "WAN-POP")
i.move_to_child_of(9)
i = Ipnet.create(:id => 95, :name => "ZGR_00014_INT_01_WAN_ZGR", :created_at => Time.now, :updated_at => Time.now, :ipaddr => "10.246.0.98", :netmask => "255.255.255.252", :lock_version =>"", :unq => "", :lvl => "4", :description => "WAN-ZGR")
i.move_to_child_of(9)
#LAN
i = Ipnet.create(:id => 96, :name => "ZGR_00014_VPN17_LAN", :created_at => Time.now, :updated_at => Time.now, :ipaddr => "10.246.0.100", :netmask => "255.255.255.252", :lock_version =>"", :unq => "", :lvl => "3", :description => "Netz")
i.move_to_child_of(9)
i = Ipnet.create(:id => 97, :name => "ZGR_00014_INT_01", :created_at => Time.now, :updated_at => Time.now, :ipaddr => "10.246.0.101", :netmask => "255.255.255.252", :lock_version =>"", :unq => "", :lvl => "4", :description => "LAN-ZGR")
i.move_to_child_of(9)
i = Ipnet.create(:id => 98, :name => "ZGR_00014_INT_01_GW", :created_at => Time.now, :updated_at => Time.now, :ipaddr => "10.246.0.102", :netmask => "255.255.255.252", :lock_version =>"", :unq => "", :lvl => "4", :description => "LAN-ÜGR")
i.move_to_child_of(9)

#VPN17 - 00005
#WAN
i = Ipnet.create(:id => 99, :name => "ZGR_00005_VPN17_WAN", :created_at => Time.now, :updated_at => Time.now, :ipaddr => "10.246.4.152", :netmask => "255.255.255.252", :lock_version =>"", :unq => "", :lvl => "3", :description => "Netz")
i.move_to_child_of(9)
i = Ipnet.create(:id => 100, :name => "ZGR_00005_INT_01_WAN_POP", :created_at => Time.now, :updated_at => Time.now, :ipaddr => "10.246.4.153", :netmask => "255.255.255.252", :lock_version =>"", :unq => "", :lvl => "4", :description => "WAN-POP")
i.move_to_child_of(9)
i = Ipnet.create(:id => 101, :name => "ZGR_00005_INT_01_WAN_ZGR", :created_at => Time.now, :updated_at => Time.now, :ipaddr => "10.246.4.154", :netmask => "255.255.255.252", :lock_version =>"", :unq => "", :lvl => "4", :description => "WAN-ZGR")
i.move_to_child_of(9)
#LAN
i = Ipnet.create(:id => 102, :name => "ZGR_00005_VPN17_LAN", :created_at => Time.now, :updated_at => Time.now, :ipaddr => "10.246.4.156", :netmask => "255.255.255.252", :lock_version =>"", :unq => "", :lvl => "3", :description => "Netz")
i.move_to_child_of(9)
i = Ipnet.create(:id => 103, :name => "ZGR_00005_INT_01", :created_at => Time.now, :updated_at => Time.now, :ipaddr => "10.246.4.157", :netmask => "255.255.255.252", :lock_version =>"", :unq => "", :lvl => "4", :description => "LAN-ZGR")
i.move_to_child_of(9)
i = Ipnet.create(:id => 104, :name => "ZGR_00005_INT_01_GW", :created_at => Time.now, :updated_at => Time.now, :ipaddr => "10.246.4.158", :netmask => "255.255.255.252", :lock_version =>"", :unq => "", :lvl => "4", :description => "LAN-ÜGR")
i.move_to_child_of(9)

#VPN17 - 00017
#WAN
i = Ipnet.create(:id => 105, :name => "ZGR_00017_VPN17_WAN", :created_at => Time.now, :updated_at => Time.now, :ipaddr => "10.246.0.112", :netmask => "255.255.255.252", :lock_version =>"", :unq => "", :lvl => "3", :description => "Netz")
i.move_to_child_of(9)
i = Ipnet.create(:id => 106, :name => "ZGR_00017_INT_01_WAN_POP", :created_at => Time.now, :updated_at => Time.now, :ipaddr => "10.246.0.113", :netmask => "255.255.255.252", :lock_version =>"", :unq => "", :lvl => "4", :description => "WAN-POP")
i.move_to_child_of(9)
i = Ipnet.create(:id => 107, :name => "ZGR_00017_INT_01_WAN_ZGR", :created_at => Time.now, :updated_at => Time.now, :ipaddr => "10.246.0.114", :netmask => "255.255.255.252", :lock_version =>"", :unq => "", :lvl => "4", :description => "WAN-ZGR")
i.move_to_child_of(9)
#LAN
i = Ipnet.create(:id => 108, :name => "ZGR_00017_VPN17_LAN", :created_at => Time.now, :updated_at => Time.now, :ipaddr => "10.246.0.116", :netmask => "255.255.255.252", :lock_version =>"", :unq => "", :lvl => "3", :description => "Netz")
i.move_to_child_of(9)
i = Ipnet.create(:id => 109, :name => "ZGR_00017_INT_01", :created_at => Time.now, :updated_at => Time.now, :ipaddr => "10.246.0.117", :netmask => "255.255.255.252", :lock_version =>"", :unq => "", :lvl => "4", :description => "LAN-ZGR")
i.move_to_child_of(9)
i = Ipnet.create(:id => 110, :name => "ZGR_00017_INT_01_GW", :created_at => Time.now, :updated_at => Time.now, :ipaddr => "10.246.0.118", :netmask => "255.255.255.252", :lock_version =>"", :unq => "", :lvl => "4", :description => "LAN-ÜGR")
i.move_to_child_of(9)

#VPN17 - 00020
#LAN
i = Ipnet.create(:id => 111, :name => "ZGR_00020_VPN17_WAN", :created_at => Time.now, :updated_at => Time.now, :ipaddr => "10.246.0.176", :netmask => "255.255.255.252", :lock_version =>"", :unq => "", :lvl => "3", :description => "Netz")
i.move_to_child_of(9)
i = Ipnet.create(:id => 112, :name => "ZGR_00020_INT_02_WAN_POP", :created_at => Time.now, :updated_at => Time.now, :ipaddr => "10.246.0.177", :netmask => "255.255.255.252", :lock_version =>"", :unq => "", :lvl => "4", :description => "WAN-POP")
i.move_to_child_of(9)
i = Ipnet.create(:id => 113, :name => "ZGR_00020_INT_02_WAN_ZGR", :created_at => Time.now, :updated_at => Time.now, :ipaddr => "10.246.0.178", :netmask => "255.255.255.252", :lock_version =>"", :unq => "", :lvl => "4", :description => "WAN-ZGR")
i.move_to_child_of(9)
#WAN
i = Ipnet.create(:id => 114, :name => "ZGR_00020_VPN17_LAN2", :created_at => Time.now, :updated_at => Time.now, :ipaddr => "10.246.0.180", :netmask => "255.255.255.252", :lock_version =>"", :unq => "", :lvl => "3", :description => "Netz")
i.move_to_child_of(9)
i = Ipnet.create(:id => 115, :name => "ZGR_00020_INT_02", :created_at => Time.now, :updated_at => Time.now, :ipaddr => "10.246.0.181", :netmask => "255.255.255.252", :lock_version =>"", :unq => "", :lvl => "4", :description => "LAN-ZGR")
i.move_to_child_of(9)
i = Ipnet.create(:id => 116, :name => "ZGR_00020_INT_02_GW", :created_at => Time.now, :updated_at => Time.now, :ipaddr => "10.246.0.182", :netmask => "255.255.255.252", :lock_version =>"", :unq => "", :lvl => "4", :description => "LAN-ÜGR")
i.move_to_child_of(9)


#34--------------
i = Ipnet.create(:id => 117, :name => "VPN_34_VoIP-Management_01", :created_at => Time.now, :updated_at => Time.now, :ipaddr => "10.246.224.0", :netmask => "255.255.240.0", :lock_version =>"", :unq => "", :lvl => "2", :description => "VPN 34")
i.move_to_child_of(2)

#VPN34 - 00004
#WAN
i = Ipnet.create(:id => 118, :name => "ZGR_00004_VPN34_WAN", :created_at => Time.now, :updated_at => Time.now, :ipaddr => "10.246.226.144", :netmask => "255.255.255.252", :lock_version =>"", :unq => "", :lvl => "3", :description => "Netz")
i.move_to_child_of(10)
i = Ipnet.create(:id => 119, :name => "ZGR_00004_INT_04_WAN_POP", :created_at => Time.now, :updated_at => Time.now, :ipaddr => "10.246.226.145", :netmask => "255.255.255.252", :lock_version =>"", :unq => "", :lvl => "4", :description => "WAN-POP")
i.move_to_child_of(10)
i = Ipnet.create(:id => 120, :name => "ZGR_00004_INT_04_WAN_ZGR", :created_at => Time.now, :updated_at => Time.now, :ipaddr => "10.246.226.146", :netmask => "255.255.255.252", :lock_version =>"", :unq => "", :lvl => "4", :description => "WAN-ZGR")
i.move_to_child_of(10)
#LAN
i = Ipnet.create(:id => 121, :name => "ZGR_00004_VPN34_LAN", :created_at => Time.now, :updated_at => Time.now, :ipaddr => "10.246.226.148", :netmask => "255.255.255.252", :lock_version =>"", :unq => "", :lvl => "3", :description => "Netz")
i.move_to_child_of(10)
i = Ipnet.create(:id => 122, :name => "ZGR_00004_INT_04", :created_at => Time.now, :updated_at => Time.now, :ipaddr => "10.246.226.149", :netmask => "255.255.255.252", :lock_version =>"", :unq => "", :lvl => "4", :description => "LAN-ZGR")
i.move_to_child_of(10)
i = Ipnet.create(:id => 123, :name => "ZGR_00004_INT_04_GW", :created_at => Time.now, :updated_at => Time.now, :ipaddr => "10.246.226.150", :netmask => "255.255.255.252", :lock_version =>"", :unq => "", :lvl => "4", :description => "LAN-ÜGR")
i.move_to_child_of(10)

#VPN34 - 00014
#WAN
i = Ipnet.create(:id => 124, :name => "ZGR_00014_VPN34_WAN", :created_at => Time.now, :updated_at => Time.now, :ipaddr => "10.246.227.120", :netmask => "255.255.255.252", :lock_version =>"", :unq => "", :lvl => "3", :description => "Netz")
i.move_to_child_of(10)
i = Ipnet.create(:id => 125, :name => "ZGR_00014_INT_03_WAN_POP", :created_at => Time.now, :updated_at => Time.now, :ipaddr => "10.246.227.121", :netmask => "255.255.255.252", :lock_version =>"", :unq => "", :lvl => "4", :description => "WAN-POP")
i.move_to_child_of(10)
i = Ipnet.create(:id => 126, :name => "ZGR_00014_INT_03_WAN_ZGR", :created_at => Time.now, :updated_at => Time.now, :ipaddr => "10.246.227.122", :netmask => "255.255.255.252", :lock_version =>"", :unq => "", :lvl => "4", :description => "WAN-ZGR")
i.move_to_child_of(10)
#LAN
i = Ipnet.create(:id => 127, :name => "ZGR_00014_VPN34_LAN", :created_at => Time.now, :updated_at => Time.now, :ipaddr => "10.246.227.124", :netmask => "255.255.255.252", :lock_version =>"", :unq => "", :lvl => "3", :description => "Netz")
i.move_to_child_of(10)
i = Ipnet.create(:id => 128, :name => "ZGR_00014_INT_03", :created_at => Time.now, :updated_at => Time.now, :ipaddr => "10.246.227.125", :netmask => "255.255.255.252", :lock_version =>"", :unq => "", :lvl => "4", :description => "LAN-ZGR")
i.move_to_child_of(10)
i = Ipnet.create(:id => 129, :name => "ZGR_00014_INT_03_GW", :created_at => Time.now, :updated_at => Time.now, :ipaddr => "10.246.227.126", :netmask => "255.255.255.252", :lock_version =>"", :unq => "", :lvl => "4", :description => "LAN-ÜGR")
i.move_to_child_of(10)

#VPN34 - 00005
#WAN
i = Ipnet.create(:id => 130, :name => "ZGR_00005_VPN34_WAN", :created_at => Time.now, :updated_at => Time.now, :ipaddr => "10.246.224.152", :netmask => "255.255.255.252", :lock_version =>"", :unq => "", :lvl => "3", :description => "Netz")
i.move_to_child_of(10)
i = Ipnet.create(:id => 131, :name => "ZGR_00005_INT_02_WAN_POP", :created_at => Time.now, :updated_at => Time.now, :ipaddr => "10.246.224.153", :netmask => "255.255.255.252", :lock_version =>"", :unq => "", :lvl => "4", :description => "WAN-POP")
i.move_to_child_of(10)
i = Ipnet.create(:id => 132, :name => "ZGR_00005_INT_02_WAN_ZGR", :created_at => Time.now, :updated_at => Time.now, :ipaddr => "10.246.224.154", :netmask => "255.255.255.252", :lock_version =>"", :unq => "", :lvl => "4", :description => "WAN-ZGR")
i.move_to_child_of(10)
#LAN
i = Ipnet.create(:id => 133, :name => "ZGR_00005_VPN34_LAN", :created_at => Time.now, :updated_at => Time.now, :ipaddr => "10.246.224.156", :netmask => "255.255.255.252", :lock_version =>"", :unq => "", :lvl => "3", :description => "Netz")
i.move_to_child_of(10)
i = Ipnet.create(:id => 134, :name => "ZGR_00005_INT_02", :created_at => Time.now, :updated_at => Time.now, :ipaddr => "10.246.224.157", :netmask => "255.255.255.252", :lock_version =>"", :unq => "", :lvl => "4", :description => "LAN-ZGR")
i.move_to_child_of(10)
i = Ipnet.create(:id => 135, :name => "ZGR_00005_INT_02_GW", :created_at => Time.now, :updated_at => Time.now, :ipaddr => "10.246.224.158", :netmask => "255.255.255.252", :lock_version =>"", :unq => "", :lvl => "4", :description => "LAN-ÜGR")
i.move_to_child_of(10)

#VPN34 - 00017
#WAN
i = Ipnet.create(:id => 136, :name => "ZGR_00017_VPN34_WAN", :created_at => Time.now, :updated_at => Time.now, :ipaddr => "10.246.224.168", :netmask => "255.255.255.252", :lock_version =>"", :unq => "", :lvl => "3", :description => "Netz")
i.move_to_child_of(10)
i = Ipnet.create(:id => 137, :name => "ZGR_00017_INT_02_WAN_POP", :created_at => Time.now, :updated_at => Time.now, :ipaddr => "10.246.224.169", :netmask => "255.255.255.252", :lock_version =>"", :unq => "", :lvl => "4", :description => "WAN-POP")
i.move_to_child_of(10)
i = Ipnet.create(:id => 138, :name => "ZGR_00017_INT_02_WAN_ZGR", :created_at => Time.now, :updated_at => Time.now, :ipaddr => "10.246.224.170", :netmask => "255.255.255.252", :lock_version =>"", :unq => "", :lvl => "4", :description => "WAN-ZGR")
i.move_to_child_of(10)
#LAN
i = Ipnet.create(:id => 139, :name => "ZGR_00017_VPN34_LAN", :created_at => Time.now, :updated_at => Time.now, :ipaddr => "10.246.224.172", :netmask => "255.255.255.252", :lock_version =>"", :unq => "", :lvl => "3", :description => "Netz")
i.move_to_child_of(10)
i = Ipnet.create(:id => 140, :name => "ZGR_00017_INT_02", :created_at => Time.now, :updated_at => Time.now, :ipaddr => "10.246.224.173", :netmask => "255.255.255.252", :lock_version =>"", :unq => "", :lvl => "4", :description => "LAN-ZGR")
i.move_to_child_of(10)
i = Ipnet.create(:id => 141, :name => "ZGR_00017_INT_02_GW", :created_at => Time.now, :updated_at => Time.now, :ipaddr => "10.246.224.174", :netmask => "255.255.255.252", :lock_version =>"", :unq => "", :lvl => "4", :description => "LAN-ÜGR")
i.move_to_child_of(10)

#VPN34 - 00020
#WAN
i = Ipnet.create(:id => 142, :name => "ZGR_00020_VPN34_WAN", :created_at => Time.now, :updated_at => Time.now, :ipaddr => "10.246.224.176", :netmask => "255.255.255.252", :lock_version =>"", :unq => "", :lvl => "3", :description => "Netz")
i.move_to_child_of(10)
i = Ipnet.create(:id => 143, :name => "ZGR_00020_INT_03_WAN_POP", :created_at => Time.now, :updated_at => Time.now, :ipaddr => "10.246.224.177", :netmask => "255.255.255.252", :lock_version =>"", :unq => "", :lvl => "4", :description => "WAN-POP")
i.move_to_child_of(10)
i = Ipnet.create(:id => 144, :name => "ZGR_00020_INT_03_WAN_ZGR", :created_at => Time.now, :updated_at => Time.now, :ipaddr => "10.246.224.178", :netmask => "255.255.255.252", :lock_version =>"", :unq => "", :lvl => "4", :description => "WAN-ZGR")
i.move_to_child_of(10)
#LAN
i = Ipnet.create(:id => 145, :name => "ZGR_00020_VPN34_LAN", :created_at => Time.now, :updated_at => Time.now, :ipaddr => "10.246.224.180", :netmask => "255.255.255.252", :lock_version =>"", :unq => "", :lvl => "3", :description => "Netz")
i.move_to_child_of(10)
i = Ipnet.create(:id => 146, :name => "ZGR_00020_INT_03", :created_at => Time.now, :updated_at => Time.now, :ipaddr => "10.246.224.181", :netmask => "255.255.255.252", :lock_version =>"", :unq => "", :lvl => "4", :description => "LAN-ZGR")
i.move_to_child_of(10)
i = Ipnet.create(:id => 147, :name => "ZGR_00020_INT_03_GW", :created_at => Time.now, :updated_at => Time.now, :ipaddr => "10.246.224.182", :netmask => "255.255.255.252", :lock_version =>"", :unq => "", :lvl => "4", :description => "LAN-ÜGR")
i.move_to_child_of(10)

#VPN34 - 00256
#WAN
i = Ipnet.create(:id => 148, :name => "ZGR_00256_VPN34_WAN", :created_at => Time.now, :updated_at => Time.now, :ipaddr => "10.246.230.168", :netmask => "255.255.255.252", :lock_version =>"", :unq => "", :lvl => "3", :description => "Netz")
i.move_to_child_of(10)
i = Ipnet.create(:id => 149, :name => "ZGR_00256_INT_32_WAN_POP", :created_at => Time.now, :updated_at => Time.now, :ipaddr => "10.246.230.169", :netmask => "255.255.255.252", :lock_version =>"", :unq => "", :lvl => "4", :description => "WAN-POP")
i.move_to_child_of(10)
i = Ipnet.create(:id => 150, :name => "ZGR_00256_INT_32_WAN_ZGR", :created_at => Time.now, :updated_at => Time.now, :ipaddr => "10.246.230.170", :netmask => "255.255.255.252", :lock_version =>"", :unq => "", :lvl => "4", :description => "WAN-ZGR")
i.move_to_child_of(10)
#LAN
i = Ipnet.create(:id => 151, :name => "ZGR_00256_VPN34_LAN", :created_at => Time.now, :updated_at => Time.now, :ipaddr => "10.246.230.172", :netmask => "255.255.255.252", :lock_version =>"", :unq => "", :lvl => "3", :description => "Netz")
i.move_to_child_of(10)
i = Ipnet.create(:id => 152, :name => "ZGR_00256_INT_32", :created_at => Time.now, :updated_at => Time.now, :ipaddr => "10.246.230.173", :netmask => "255.255.255.252", :lock_version =>"", :unq => "", :lvl => "4", :description => "LAN-ZGR")
i.move_to_child_of(10)
i = Ipnet.create(:id => 153, :name => "ZGR_00256_INT_32_GW", :created_at => Time.now, :updated_at => Time.now, :ipaddr => "10.246.230.174", :netmask => "255.255.255.252", :lock_version =>"", :unq => "", :lvl => "4", :description => "LAN-ÜGR")
i.move_to_child_of(10)



#Ipnet.create(:id => 9, :name => "VPN_01_Landesbehörden_02", :created_at => Time.now, :updated_at => Time.now, :ipaddr => "10.8.16.0", :netmask => "255.255.254.0", :parent_id => "", :lft => "", :rgt =>"", :lock_version =>"", :unq => "", :lvl => "", :description => "")
#Ipnet.create(:id => 10, :name => "VPN_02_Finanzverwaltung_02", :created_at => Time.now, :updated_at => Time.now, :ipaddr => "10.8.18.0", :netmask => "255.255.254.0", :parent_id => "", :lft => "", :rgt =>"", :lock_version =>"", :unq => "", :lvl => "", :description => "")
#Ipnet.create(:id => 11, :name => "VPN_03_Justiz/Amtsgerichte_02", :created_at => Time.now, :updated_at => Time.now, :ipaddr => "10.8.20.0", :netmask => "255.255.254.0", :parent_id => "", :lft => "", :rgt =>"", :lock_version =>"", :unq => "", :lvl => "", :description => "")
#Ipnet.create(:id => 12, :name => "VPN_04_Justiz/Staatsanwaltschaften_02", :created_at => Time.now, :updated_at => Time.now, :ipaddr =>"10.8.22.0", :netmask => "255.255.254.0", :parent_id => "", :lft => "", :rgt =>"", :lock_version =>"", :unq => "", :lvl => "", :description => "")
#Ipnet.create(:id => 13, :name => "VPN_05_Polizei/Vollzug_02", :created_at => Time.now, :updated_at => Time.now, :ipaddr => "10.8.24.0", :netmask => "255.255.254.0", :parent_id => "", :lft => "", :rgt =>"", :lock_version =>"", :unq => "", :lvl => "", :description => "")
#Ipnet.create(:id => 14, :name => "VPN_06_Sozialwesen_02", :created_at => Time.now, :updated_at => Time.now, :ipaddr => "10.8.26.0", :netmask => "255.255.254.0", :parent_id => "", :lft => "", :rgt =>"", :lock_version =>"", :unq => "", :lvl => "", :description => "")
#Ipnet.create(:id => 14, :name => "VPN_17_Voice_02", :created_at => Time.now, :updated_at => Time.now, :ipaddr => "10.8.46.0", :netmask => "255.255.254.0", :parent_id => "", :lft => "", :rgt =>"", :lock_version =>"", :unq => "", :lvl => "", :description => "")
#Ipnet.create(:id => 14, :name => "VPN_34_VoIP-Management_02", :created_at => Time.now, :updated_at => Time.now, :ipaddr => "10.8.15.0", :netmask => "255.255.255.0", :parent_id => "", :lft => "", :rgt =>"", :lock_version =>"", :unq => "", :lvl => "", :description => "")