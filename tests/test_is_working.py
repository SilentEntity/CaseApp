
def test_flask_working(client):
    response = client.get("/working")
    assert response.data == b"flask is working"