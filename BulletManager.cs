using Godot;
using System;

public partial class BulletManager : Node2D
{
	public void HandleBulletSpawned(Bullet bullet, Vector2 position, Vector2 direction)
	{
		AddChild(bullet);
		//bullet.Team = team;
		bullet.GlobalPosition = position;
		bullet.SetDirection(direction);
	}
}
