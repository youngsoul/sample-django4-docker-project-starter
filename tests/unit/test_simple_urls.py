def test_say_hello(client):
    resp = client.get(f"/say_hello") # assume you have a view at localhost:8000/say_hello
    assert resp.status_code == 301
