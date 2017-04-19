SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure [dbo].[Inv_ProdUMCrea_4]
@RucE nvarchar(11),
@Cd_Prod char(7),
@Cd_UM char(2),
@DescripAlt varchar(100),
@Factor numeric(13,3),
@PesoKg numeric(18,3),
@Volumen numeric(18,3),
@EstadoUMP bit,
@IB_UMPPrin bit,
@IC_CL char,
@msj varchar(100) output
as

if exists (select * from Prod_UM where RucE = @RucE and Cd_Prod=@Cd_Prod and Cd_UM = @Cd_UM and Factor=@Factor)
      set @msj = 'Ya existe Producto y Unidad de medida con ese factor'
else
begin
	if (@IB_UMPPrin =1)
	begin
		update Prod_UM set IB_UMPPrin=0 where RucE=@RucE and Cd_Prod=@Cd_Prod
	end

      insert into Prod_UM(RucE,Cd_Prod,Id_UMP,Cd_UM,DescripAlt,Factor,PesoKg,Volumen,EstadoUMP,IB_UMPPrin, IC_CL)
                values(@RucE,@Cd_Prod,dbo.Id_UMP(@RucE,@Cd_Prod),@Cd_UM,@DescripAlt,@Factor,@PesoKg,@Volumen,@EstadoUMP,@IB_UMPPrin, @IC_CL)
      
      if @@rowcount <= 0
         set @msj = 'Producto por Unidad de Medida no pudo ser creada'

end
print @msj

-- CE: crecion del sp -> se adiciono EstadoUMP
-- CE: 12/01/2013 -> Se agrego IB_EsPrin
GO
