using RubiksCube.Engine.Contracts;

namespace RubiksCube.Engine {
    internal static class CubeExtensions {
        public static int Idx(this Color color) => (int)color;
        public static int Idx(this Side side) => (int)side;
    }
}
