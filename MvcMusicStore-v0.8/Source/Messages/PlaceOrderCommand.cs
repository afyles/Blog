using MvcMusicStore.Models;
using System;

namespace Messages
{
    public interface IPlaceOrderCommand : ICommand
    {
        String CartId { get; set; }
        Int32 OrderId { get; set; }
    }
}
