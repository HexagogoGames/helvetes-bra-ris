# linux-surface — installationsplan (research klar, inte påbörjat)

Research gjord 2026-09-15 via linux-surfaces officiella GitHub-wiki +
verifierat mot den här maskinen. Inget av detta är kört än — det här är
en färdig checklista för när Jakob är redo.

## Bra nyheter, verifierat på den här maskinen

- **Secure Boot är avstängt** (`bootctl status` → "disabled (setup)") —
  hela MOK-nyckel-registreringssteget (`linux-surface-secureboot-mok`,
  omstart in i en blå MokManager-meny, lösenord `surface`) **behövs inte**.
  Stor förenkling jämfört med standardguiden.
- **`dracut`, inte `mkinitcpio`**, är redan initramfs-verktyget här
  (`60-dracut-remove.hook`/`90-dracut-install.hook` finns) — pacman
  regenererar initramfs automatiskt när kärnpaketet installeras, inget
  extra manuellt steg.
- **GRUB** (inte systemd-boot) är bootloadern, config i `/etc/default/grub`
  → `/boot/grub/grub.cfg`.
- Den vanliga `linux`-kärnan **stannar kvar parallellt** — `linux-surface`
  installeras som ett eget kärnpaket, väljs i GRUB-menyn vid uppstart.
  Går att välja bort/avinstallera senare utan att förlora något.

## Möjlig direkt koppling till strömknapps-/ACPI-problemet

Surface Laptop 6-sidan i wikin dokumenterar ett känt
**"shutdown problem"** för just den här modellen, med fix via
kärnparametern `acpi_osi="Windows 2022"`. Det är precis den sortens
ACPI-kompatibilitetsflagga som skulle kunna få `PNP0C0C`
(strömknappen, se [[../03-felsokning/strömknapp-syns-inte]]) att faktiskt
dyka upp för Linux. Ingen garanti, men värt att testa specifikt för det —
inte bara `s2idle`-problemet.

En andra känd Surface Laptop 6-bugg (överhettning + ACPI GPE-fel i dmesg)
har en separat fix: kärnparametern `pci=hpiosize=0`.

## Checklista

1. **Importera och signera projektets paketnyckel** (talar om för pacman
   att lita på paket signerade av linux-surface-teamet):
   ```bash
   curl -s https://raw.githubusercontent.com/linux-surface/linux-surface/master/pkg/keys/surface.asc \
       | sudo pacman-key --add -
   sudo pacman-key --finger 56C464BAAC421453
   sudo pacman-key --lsign-key 56C464BAAC421453
   ```
   Andra raden visar nyckelns fingeravtryck så man kan kontrollera att det
   är rätt nyckel innan man litar på den lokalt (tredje raden).

2. **Lägg till paketkällan** i `/etc/pacman.conf` (kräver `sudo`-redigering,
   inget enradskommando):
   ```
   [linux-surface]
   Server = https://pkg.surfacelinux.com/arch/
   ```

3. **Uppdatera paketlistor och installera kärnan + kärnpaket:**
   ```bash
   sudo pacman -Syu
   sudo pacman -S linux-surface linux-surface-headers iptsd
   ```
   `-Syu` uppdaterar HELA systemet, inte bara den nya källan — normalt
   och bra att göra ändå, men värt att veta att det gör mer än att bara
   plocka upp linux-surface-paketen. `iptsd` är en användarrymdsdemon för
   pekskärm/penna (hanteras i mjukvara på de här enheterna, inte i
   kärnan).

4. **Pennstöd via AUR** (kräver `yay`, redan installerat):
   ```bash
   yay -S libwacom-surface
   ```
   OBS: samma sorts AUR-paket som `wallust` som hade ett trasigt
   checksum-fel tidigare idag — om samma sak händer, samma fix
   (`updpkgsums && makepkg -si` i byggmappen).

5. **Ingen secure-boot-registrering behövs** (redan avstängt, se ovan) —
   hoppa över `linux-surface-secureboot-mok` helt.

6. **Lägg till de Surface Laptop 6-specifika kärnparametrarna** i
   `/etc/default/grub`, raden `GRUB_CMDLINE_LINUX_DEFAULT` (nuvarande
   innehåll: `'nowatchdog nvme_load=YES loglevel=3'`) — lägg till
   `acpi_osi="Windows 2022"` och `pci=hpiosize=0` i samma sträng, sedan:
   ```bash
   sudo grub-mkconfig -o /boot/grub/grub.cfg
   ```
   Det här kommandot läser om `/etc/default/grub` och skriver om GRUB:s
   faktiska startmeny/config utifrån den — utan det här steget märks
   ändringen i `/etc/default/grub` aldrig av vid uppstart.

7. **Starta om**, välj `linux-surface` i GRUB-menyn (den vanliga `linux`-
   kärnan finns kvar som reserv i samma meny).

8. **Verifiera:**
   ```bash
   uname -r
   ```
   ska innehålla ordet "surface". Sedan: kolla om `PNP0C0C` dykt upp
   (`ls /sys/bus/acpi/devices/ | grep PNP0C0`) och testa strömknappen på
   riktigt.

## Status

Inte påbörjat. Jakob har sagt "senare" — den här filen är den konkreta
planen redo att köras när han är redo, se [[vantar-pa-jakob]].
