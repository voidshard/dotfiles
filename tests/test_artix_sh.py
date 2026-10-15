import os
import stat


def test_script_exists():
    path = os.path.abspath('artix.sh')
    assert os.path.exists(path), f"Installer script not found at {path}"


def test_executable():
    path = os.path.abspath('artix.sh')
    mode = os.stat(path).st_mode
    assert mode & stat.S_IXUSR, "artix.sh should be executable"


def test_mentions_hyprland_and_ml4w():
    path = os.path.abspath('artix.sh')
    with open(path, 'r') as f:
        content = f.read().lower()
    assert 'hyprland' in content, "Script should mention hyprland"
    assert 'ml4w' in content, "Script should mention ml4w"


def test_respects_no_install_env():
    path = os.path.abspath('artix.sh')
    with open(path, 'r') as f:
        content = f.read()
    assert 'NO_INSTALL' in content or 'CI' in content
