<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<MvcMusicStore.ViewModels.ShoppingCartViewModel>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Cart Updated!
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <h3>
        <em>Item Added!</em>
    </h3>
    <p class="button">
        <%: Html.ActionLink("Checkout >>", "AddressAndPayment", "Checkout")%>
    </p>

    <div id="update-message"></div>

    <table>

        <tr>
            <th>Album Name</th>
            <th>Price (each)</th>
            <th>Quantity</th>
        </tr>

        <% foreach (var item in Model.CartItems) { %>
        <tr id="row-<%: item.RecordId %>">
            <td>
                <%: Html.ActionLink(item.Album.Title, "Details", "Store", new { id = item.AlbumId }, null)%>
            </td>
            <td>
                <%: item.Album.Price %>
            </td>
            <td>
                <%: item.Count %>
            </td>
        </tr>
        <% } %>

        <tr>
            <td>Estimated Total</td>
            <td></td>
            <td id="cart-total">
                <%: Model.CartTotal %>
            </td>
        </tr>

    </table>

</asp:Content>
