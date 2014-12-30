package actions;
import ze.component.core.Component;
import ze.component.graphic.tilesheet.AnimatedSprite;
import ze.component.physics.Collider;
import ze.object.GameObject;

/**
 * ...
 * @author Goh Zi He
 */
class Respawn extends Component
{
	override public function added():Void 
	{
		super.added();
		collider.registerCallback(hit);
	}
	
	private function hit(collider:Collider):Void
	{
		if (collider.gameObject.name == "player")
		{
			var player:Player = collider.gameObject.getComponent(Player);
			player.respawnPoint = this;
			disableAllRespawnPoint();
		}
	}
	
	private function disableAllRespawnPoint():Void
	{
		var respawnPoints:Array<GameObject> = scene.getGameObjectsByName("respawn");
		for (go in respawnPoints)
		{
			var anim:AnimatedSprite = go.getComponent(AnimatedSprite);
			if (go == gameObject)
			{
				anim.play("activated", 10);
			}
			else
			{
				anim.play("idle", 10);
			}
		}
	}
}