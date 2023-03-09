namespace RubiksCube.Engine.Contracts
{
    public struct Movement
    {
        public Side Side { get; }
        public Rotation Rotation { get; }
        public Movement(Side side, Rotation rotation = Rotation.Right)
        {
            Side = side;
            Rotation = rotation;
        }
    }
}
