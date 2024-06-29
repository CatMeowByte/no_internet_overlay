# No Internet Overlay

**"No Internet" Overlay** is a simple utility to cover the screen with a prominent graphic popup indicating that the computer is not connected to the internet.

![Screenshot_2024-06-15_19-24-54](https://github.com/CatMeowByte/no_internet_overlay/assets/136966673/e8478517-2745-424d-bafe-a34491f1ed88)

## Arguments:

- `--info`: Display detailed information about the application and exit.
- `--timeout=<seconds>`: Set the HTTP request timeout in seconds.
- `--refresh=<seconds>`: Set the interval between ping attempts in seconds.
- `--bg-color=<color>`: Set the background color of the overlay (`red`, `orange`, `yellow`, `gray`).
- `--bg-alpha=<value>`: Set the background opacity (Range: 0.0 to 0.875).
- `--fg-alpha=<value>`: Set the graphic opacity (Range: 0.0 to 1.0).
- `--blink`: Enable the graphic to blink.

### Examples:

```
no_internet_overlay --timeout=15 --refresh=30 --bg-color=yellow --bg-alpha=0.5 --fg-alpha=0.8 --blink
```

## Installation

To run `no_internet_overlay` at startup, follow these steps:

### Running `no_internet_overlay` at Startup

#### Linux

1. **Create a Desktop Entry:**

   Create a `.desktop` file in `~/.config/autostart/`. You can name it `no_internet_overlay.desktop`:

   ```ini
   [Desktop Entry]
   Type=Application
   Name=No Internet Overlay
   Exec=/path/to/no_internet_overlay --timeout=15 --refresh=30 --bg-color=yellow --bg-alpha=0.5 --fg-alpha=0.8 --blink
   Terminal=false
   ```

   Replace `/path/to/no_internet_overlay` with the actual path where `no_internet_overlay` resides.

2. **Make the Desktop Entry Executable:**

   Open a terminal and make the `.desktop` file executable with the following command:

   ```bash
   chmod +x ~/.config/autostart/no_internet_overlay.desktop
   ```

3. **Log Out and Log In:**

   Restart your Linux system or log out and log back in to see `no_internet_overlay` start automatically.

#### Windows

Use the Task Scheduler:

1. **Open Task Scheduler:**

   - Press `Win + R` to open the Run dialog.
   - Type `taskschd.msc` and press Enter to open Task Scheduler.

2. **Create a New Task:**

   - Click on "Create Task..." in the Actions panel on the right.

3. **General Settings:**

   - In the General tab:
     - Name: Enter a name for your task (e.g., No Internet Overlay).
     - Description: Optionally, add a description.

4. **Triggers:**

   - In the Triggers tab:
     - Click "New..."
     - Choose "At log on" from the Begin the task dropdown.
     - Click OK.

5. **Actions:**

   - In the Actions tab:
     - Click "New..."
     - In the Program/script field, browse and select `no_internet_overlay`.
     - In the Add arguments field, enter your desired command-line options, such as `--timeout=15 --refresh=30 --bg-color=yellow --bg-alpha=0.5 --fg-alpha=0.8 --blink`.
     - Click OK.

6. **Conditions and Settings:**

   - Optionally, adjust conditions and settings as needed in the Conditions and Settings tabs.

7. **Save and Exit:**

   - Click OK to save the task.

## Information

This project is licensed under [GPLv3+](https://spdx.org/licenses/GPL-3.0-or-later.html "GNU General Public License version 3 or later").

This project follows the [HGG](https://catmeowbyte.github.io/heretic_git_guidelines "Heretic Git Guidelines").