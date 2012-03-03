// Apply this script to every object to turn gold.
// On collision, spawns a projector looking at the point.
// The Projector applies the specified material to _only_
// this object.

function Start () {
  
}

function Update () {
  
}

function OnCollisionEnter (collision : Collision) {
  // Debug-draw all contact points and normals
  for (var contact : ContactPoint in collision.contacts) {
    Debug.DrawRay(contact.point, contact.normal, Color.white);
  }
  var proj : Projector;
  proj = gameObject.AddComponent ("Projector");
}

function OnCollisionStay (collision : Collision) {
  
}

function OnCollisionExit (collision : Collision) {
  
}