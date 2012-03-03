public var target : Transform;
public var speed : float = 10;

function Update () {
	transform.RotateAround(target.position,Vector3.up, speed * Time.deltaTime);
}