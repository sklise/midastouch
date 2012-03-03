public var speed : float = -4;

function Update () {
	transform.Rotate(Vector3.up, speed * Time.deltaTime);
}