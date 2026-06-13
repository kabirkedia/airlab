# `/etc/airlab/signals/` — robot state signals

This folder holds small, **permission-guarded marker files** ("signals") that gate what may happen on
this computer. They are **root-owned** (an unprivileged agent user cannot create or remove them) and the
folder is **world-readable** (`0755`) so any component — the Action Broker, a robot driver — can check a
signal's presence without special privileges.

Each signal is just a file whose **presence/absence** is the state (contents are ignored):

| Signal | Read by | present ⇒ | absent ⇒ |
|---|---|---|---|
| `MOTIONLESS` | the **Action Broker** | the robot is declared safe → the Broker **permits** guarded actions on it | the Broker **refuses** guarded actions (a universal hard gate) |
| `MOTION_ENABLED` | the **robot driver** | the driver may actuate | the driver must **not** move (the fail-safe default) |

`MOTION_ENABLED` is the *inverted, fail-safe* control for the driver: it actuates **only** when the file is
present, so a freshly-started / late-joining node defaults to **no motion**. `MOTIONLESS` and `MOTION_ENABLED`
are meant to be **mutually exclusive** — never both present (that would be "the Broker may operate while the
driver may move").

**Default after install:** `MOTIONLESS` present (safe — the robot is motionless until a human explicitly
makes it operational). Install does not clobber an existing state on upgrade.

**Managing the signals:** use `motion-ctl.sh` (from the agent-framework / Broker tooling), run on this host:

    sudo motion-ctl.sh motionless    # MOTIONLESS on,  MOTION_ENABLED off  (maintenance: Broker may operate)
    sudo motion-ctl.sh operational   # MOTIONLESS off, MOTION_ENABLED on   (normal duty: robot may move)
    sudo motion-ctl.sh safe          # both off                            (cold default)
         motion-ctl.sh status

Creating `MOTIONLESS` / clearing `MOTION_ENABLED` is the **safe** direction (a human *or* the Broker may do
it); enabling motion is a deliberate **human** action. Keep the path in sync with what the Broker is
configured to check for this system (`robots.yaml` may override it per-system).
