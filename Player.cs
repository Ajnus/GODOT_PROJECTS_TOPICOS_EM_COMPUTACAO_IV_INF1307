using Godot;
using System;
using System.ComponentModel;

public partial class Player : Area2D
{
	[Export]

	// How fast the player will move (pixels/sec).
	public int Speed { get; set; } = 400;

	[Export]
	public PackedScene BulletScene { get; set; }

	// Size of the game window.
	public Vector2 ScreenSize;
	
	[Signal]
	public delegate void HitEventHandler();

	[Signal]
	public delegate void PlayerFiredBowEventHandler(Bullet bullet, Vector2 position, Vector2 direction);

	//var endOfGun = GetNode<EndOfGun>("EndOfGun");
	public Node2D EndOfBow;


	public void Start(Vector2 position)
	{
		Position = position;
		Show();
		GetNode<CollisionShape2D>("CollisionShape2D").Disabled = false;
	}
	
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		EndOfBow = GetNode<Node2D>("EndOfBow");
		ScreenSize = GetViewportRect().Size;
		
		//Player.BodyEntered += OnBodyEntered(this);
		//node.NomeSinal += Função();
		// Conectar o sinal 'body_entered' do Player ao método 'OnBodyEntered'
		//Player.Connect("body_entered", this, nameof(OnBodyEntered(Node2D body)));
		
		// Crie um objeto Callable encapsulando o método OnBodyEntered
		//Godot.Callable method = new Godot.Callable(this, nameof(OnBodyEntered(body)));

		// Conectar o sinal 'body_entered' do Player ao método 'OnBodyEntered'
		//Player.Connect("body_entered", method);
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
		// Speed * delta;
		// The player's movement vector.
		var velocity = Vector2.Zero;

		if (Input.IsActionPressed("move_right"))
			velocity.X += 1;

		if (Input.IsActionPressed("move_left"))
			velocity.X -= 1;

		if (Input.IsActionPressed("move_down"))
			velocity.Y += 1;

		if (Input.IsActionPressed("move_up"))
			velocity.Y -= 1;
		
		if (Input.IsActionJustReleased("shoot"))
			Shoot();


		var animatedSprite2D = GetNode<AnimatedSprite2D>("AnimatedSprite2D");

	/*	var sprite_frames = $AnimatedSprite2D.sprite_frames
			Get the first texture of the wanted animation (in this case, walk, you can also get the size
			in differents cases)
			If your animation frames has different sizes, use $AnimatedSprite2D.frame instead of 0
		var texture       = sprite_frames.get_frame_texture("walk", 0)
			Get frame size:
		var texture_size  = texture.get_size()
			This is not the end, you will get the texture size, not the node real size, then you need to
			multiply the texture size with the node scale
		var as2d_size     = texture_size * $AnimatedSprite2D.get_scale()*/
	
		if (velocity.Length() > 0)
		{
			velocity = velocity.Normalized() * Speed;
			animatedSprite2D.Play();
		}

		else
		{
			animatedSprite2D.Stop();
		}
		
		Position += velocity * (float)delta;

		Position = new Vector2(
			x: Mathf.Clamp(Position.X, 27, ScreenSize.X-27),
			y: Mathf.Clamp(Position.Y, 33.75f, ScreenSize.Y-33.75f) 
		);
		
		if (velocity.X != 0)
		{
			animatedSprite2D.Animation = "walk";
			animatedSprite2D.FlipV = false;

			// See the note below about boolean assignment.
			animatedSprite2D.FlipH = velocity.X < 0;
		}

		else if (velocity.Y != 0)
		{
			animatedSprite2D.Animation = "up";
			animatedSprite2D.FlipV = velocity.Y > 0;
		}

		LookAt(GetGlobalMousePosition());
	}
	
	private void OnBodyEntered(Node2D body)
	{
		Hide(); // Player disappears after being hit.
		EmitSignal(SignalName.Hit);

		// Must be deferred as we can't change physics properties on a physics callback.
		GetNode<CollisionShape2D>("CollisionShape2D").SetDeferred(CollisionShape2D.PropertyName.Disabled, true);	
	}
	
	private void Shoot()
	{
		
		Bullet bulletInstance = BulletScene.Instantiate<Bullet>();
		GD.Print("shoot!");
		//bulletInstance.GlobalPosition = EndOfBow.GlobalPosition;
		var target = GetGlobalMousePosition();
		//Vector2 directionToMouse = (target - bulletInstance.GlobalPosition).Normalized();
		Vector2 directionToMouse = EndOfBow.GlobalPosition.DirectionTo(target).Normalized();

		//bulletInstance.SetDirection(directionToMouse.Normalized());
		EmitSignal(SignalName.PlayerFiredBow, bulletInstance, EndOfBow.GlobalPosition, directionToMouse);
	}
	
}
