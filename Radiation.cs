using System;

namespace RadiationMaker
{
    public class Radiation
    {
        public DateTime TimeStamp => DateTime.UtcNow;
        public int Level => new Random().Next(-1, 60000000);
    }
}