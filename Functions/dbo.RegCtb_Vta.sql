SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS OFF
GO
CREATE FUNCTION [dbo].[RegCtb_Vta](@RucE nvarchar(11), @Cd_MR nvarchar(2), @Cd_Area nvarchar(6), @Eje nvarchar(4), @Prdo nvarchar(2))
returns nvarchar(15) AS
begin 
      declare @c nvarchar(15), @n int, @MD varchar(5), @AR varchar(5)

      select @MD = NCorto from Modulo where Cd_MR=@Cd_MR
      select @AR = NCorto from Area where RucE=@RucE and Cd_Area=@Cd_Area
      select @c = count(RegCtb) from Venta where RucE=@RucE and Cd_MR=@Cd_MR and Eje=@Eje and Prdo=@Prdo and Cd_Area=@Cd_Area
      if @c=0
	begin
	set @c= @MD+@AR+'_RV'+@Prdo+ '-00001'
	end
      else
	begin
	select @c=max(right(RegCtb,5)) from Venta where RucE=@RucE and Cd_MR=@Cd_MR and Eje=@Eje and Prdo=@Prdo and Cd_Area=@Cd_Area
	set @c= right(@c,5)  --> solo es necesario si lleva una letra adelante
	set @n =convert(int, @c)+1
	set @c = @MD+@AR+'_RV'+@Prdo+'-'+right('00000'+ltrim(str(@n)), 5)
	end
       return @c

end
GO
