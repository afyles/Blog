namespace Server.Core
{
    using System;

    public class Department
    {
        public virtual Int16 Id { get; set; }
        public virtual String Name { get; set; }
        public virtual String GroupName { get; set; }
        public virtual DateTime ModifiedDate { get; set; }
    }
}
