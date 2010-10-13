namespace Server
{
    using System;

    public interface IUnitOfWork : IDisposable
    {
        void Enlist();
        void Complete();
        void Rollback();
    }
}
