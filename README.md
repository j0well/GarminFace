# London Time – Garmin watch face (Forerunner 255 Music)

A simple Connect IQ watch face that shows:

- **Your local time**, taken from the watch clock. The watch syncs its time and time zone from your phone (Garmin Connect over Bluetooth) or GPS, so this follows you when you travel.
- **London time**. The face takes the same synced clock and applies London's offset itself: GMT in winter, BST in summer. It switches automatically on the last Sunday of March and the last Sunday of October.
- **Date** as MM/DD/YYYY
- **Battery %**
- **Your own JPG as the background**

It respects the watch's 12h/24h setting.

## Use your own background

1. Replace `resources/drawables/background.jpg` with your picture. Keep the file name.
2. Crop it to **260 × 260 px** for the Forerunner 255 / 255 Music (218 × 218 for the 255S). The image is centered and not scaled.
3. The 255 has a 64-colour screen, so the build dithers the photo. Bold, high-contrast images look best.

## Build and install

1. Install the [Connect IQ SDK](https://developer.garmin.com/connect-iq/sdk/) and the **Monkey C** extension for VS Code.
2. In VS Code run **Monkey C: Generate a Developer Key** (once).
3. Open this folder, then run **Monkey C: Build for Device** and pick `fr255m` (Forerunner 255 Music).
4. Plug the watch in with USB and copy the generated `.prg` file into `GARMIN/APPS/` on the watch.
5. On the watch, hold **UP**, go to **Watch Face**, and pick **London Time**.

To try it without the watch, use **Monkey C: Run** to open the simulator.

Command-line build:

```sh
monkeyc -d fr255m -f monkey.jungle -o bin/LondonTime.prg -y /path/to/developer_key.der
```

## Files

| File | Purpose |
| --- | --- |
| `source/LondonFaceView.mc` | Draws the face (background, time, date, London, battery) |
| `source/LondonTime.mc` | London GMT/BST offset calculation |
| `resources/drawables/background.jpg` | Your background picture |
