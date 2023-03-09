namespace RubiksCube.Engine.Contracts
{

    [Serializable]
    public sealed class CubeException : Exception
    {
        public CubeException(string message) : base(message) { }
    }
}
