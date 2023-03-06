namespace RubiksCube.Engine {
    public struct Movement {
        public Side Side;
        public Rotation Rotation;
        public Movement(Side side, Rotation rotation = Rotation.Right) {
            Side = side;
            Rotation = rotation;
        }
    }
}
