from CTFd.utils import get_app_config, get_config
from CTFd.utils.config import is_setup


def mlc():
    print(get_app_config("OAUTH_PROVIDER"))
    if get_app_config("OAUTH_PROVIDER") != "mlc":
        return False
    if not is_setup():
        return True
    return get_config("oauth_client_id") and get_config("oauth_client_secret")


def ctftime():
    print(get_app_config("OAUTH_PROVIDER"))
    if get_app_config("OAUTH_PROVIDER") != "ctftime":
        return False
    if not is_setup():
        return True
    return get_config("oauth_client_id") and get_config("oauth_client_secret")


def oauth_registration():
    v = get_config("registration_visibility")
    return v in ["mlc", "ctftime"]
