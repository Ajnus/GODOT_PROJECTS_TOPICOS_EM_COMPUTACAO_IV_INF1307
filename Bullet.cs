using Godot;
using System;

public partial class Bullet : Area2D
{
	[Export]
	public int Speed { get; set; } = 10;

	private Vector2 direction = Vector2.Zero;

	private Timer killTimer;

	//private int team = -1;

	private AudioStreamPlayer audioPlayer;
	private Timer frostTimer;

	[Signal]
	public delegate void HitEventHandler();

	private Mob collidedMob;

	public override void _Ready()
	{
		audioPlayer = GetNode<AudioStreamPlayer>("Frosted");
		killTimer = GetNode<Timer>("KillTimer");
		killTimer.Start();
	}

	public override void _PhysicsProcess(double delta)
	{
		var animatedSprite2D = GetNode<AnimatedSprite2D>("AnimatedSprite2D");

		if (direction != Vector2.Zero)
		{
			GetNode<AnimatedSprite2D>("AnimatedSprite2D").FlipH = true;
			var velocity = direction * Speed;

			GlobalPosition += velocity;
		}
	}

	public void SetDirection(Vector2 direction)
	{
		this.direction = direction;
	}

	private void OnBodyEntered(Node2D body)
	{
		collidedMob = body as Mob;

		PlaySound();
		Hide();

		frostTimer = GetNode<Timer>("FrostTimer");
		frostTimer.Start();

		/*if (!frostTimer.IsStopped())
		{
			GD.Print("frostTimer foi iniciado com sucesso!");
		}
		else
		{
			GD.Print("frostTimer não foi iniciado!");
		}*/

		// Must be deferred as we can't change physics properties on a physics callback.
		GetNode<CollisionShape2D>("CollisionShape2D").SetDeferred(CollisionShape2D.PropertyName.Disabled, true);
	}

	private void PlaySound()
	{
		audioPlayer.Play();
	}

	private void OnKillTimerTimeout()
	{
		QueueFree();
	}

	private void OnFrostTimerTimeoutCallback()
	{
		OnFrostTimerTimeout(collidedMob);
	}

	private void OnFrostTimerTimeout(Mob collidedMob)
	{
		GD.Print("OnFrostTimerTimeout");
		collidedMob.QueueFree();
	}
}
