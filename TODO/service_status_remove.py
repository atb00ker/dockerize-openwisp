
# TODO: REMOVE THIS
# def sslrequire_status():
#     base_path = "/etc/letsencrypt/"
#     "live /${TOPOLOGY_DOMAIN}/privkey.pem"
#     dashboard_path = [base_path, "live",
#                       os.environ['DASHBOARD_DOMAIN'], "privkey.pem"]
#     controller_path = [base_path, "live",
#                        os.environ['CONTROLLER_DOMAIN'], "privkey.pem"]
#     radius_path = [base_path, "live",
#                    os.environ['RADIUS_DOMAIN'], "privkey.pem"]
#     topology_path = [base_path, "live",
#                      os.environ['TOPOLOGY_DOMAIN'], "privkey.pem"]
#     try:
#         open(os.path.join(*dashboard_path), 'r')
#         open(os.path.join(*controller_path), 'r')
#         open(os.path.join(*radius_path), 'r')
#         open(os.path.join(*topology_path), 'r')
#         open(os.path.join(base_path, "openwisp-dhparams.pem"), 'r')
#     except FileNotFoundError:
#         time.sleep(3)
#         return False
#     else:
#         return True

# TODO: Remove this!
# if "sslrequire" in arguments:
#     print("Waiting for all SSL certificates to be created...")
#     connected = False
#     while not connected:
#         connected = sslrequire_status()
#     print("All SSL certificates found.")
