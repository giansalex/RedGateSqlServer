SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [User123].[Nro_SC](@RucE nvarchar(11))
returns char(15) AS
begin 
      declare @c char(15), @n int
      select @c = count(NroSC) from SolicitudCom where RucE=@RucE
      if @c=0
	set @c='NRO-00000000001'
      else
	begin
	select @c=max(NroSC) from SolicitudCom where RucE=@RucE
	set @c= right(@c,11)
	set @n =convert(int, @c)+1
	set @c = 'NRO-'+right('00000000000'+ltrim(str(@n)), 11)
	end
       return @c
end

GO
