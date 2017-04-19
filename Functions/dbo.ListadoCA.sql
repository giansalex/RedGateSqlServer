SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE FUNCTION [dbo].[ListadoCA](@RucE nvarchar(11),@Cd_MR varchar(2),@Cd_Tab varchar(4),@val2 varchar(100),@CA varchar(4))
returns varchar(100) AS
begin 
	
	declare @val1 varchar(100)= 
		(
		select 	con.ValList--,cam.NomCol
		from 	CfgCampos con 
		inner join CampoTabla cam on cam.Id_CTb = con.Id_CTb
		inner join TipoDato td on td.Id_TDt = con.Id_TDt
		inner join Tabla t on t.Cd_Tab = cam.Cd_Tab
		inner join Tablaxmod tm on t.Cd_tab = tm.Cd_Tab
		where 	con.RucE=@RucE and tm.Cd_MR =@Cd_MR and t.Cd_Tab = @Cd_Tab and cam.estado=1 and cam.NomCol=@CA -- and td.Id_TDt=15
		)
	--'Enero Febrero Marzo Abril Mayo Junio Julio'
    declare @lstDato varchar(100)
	declare @adicional varchar(100)
	declare @valespacio int
	declare @valesp int
	declare @resul varchar(100) = ''
	declare @cont int = 1
	declare @ayuda varchar(100)
	declare @space char(1) = (select right(left(ValList, 8),1)from cfgcampos where ruce='11111111111' and ValList is not null and Id_CTb = '58')
	-----------------------------
	while(len(@val2) >0)  
	begin
		SET @valespacio = CHARINDEX(', ', @val2 )
		IF ( @valespacio=0 )
		BEGIN 
			SET @lstDato = @val2
				set @ayuda = @val1    
				while(len(@val1) >0) 
				begin			
					SET @valesp = CHARINDEX(@space, @val1 )
					IF ( @valesp=0 )
					 BEGIN 
						SET @adicional = @val1
						--------------------------
						if(@lstDato = @adicional)
						 begin
							set @resul += convert(varchar(1),@cont)
							set @cont = @cont +1
							--print @resul
						 end	
						else 	
						 begin
							set @cont = @cont +1
						 end	
						--------------------------
						SET @val1 = ''
					 END
					ELSE
					 begin
						SET @adicional = Substring( @val1 , 1  , @valesp-1) 
						if(@lstDato = @adicional)
						 begin
							set @resul += convert(varchar(1),@cont)
							set @cont = @cont +1
							--print @resul
						 end	
						else 	
						 begin
							set @cont = @cont +1
						 end	
						SET @val1 = Substring( @val1 , @valesp + 1 , LEN(@val1))
					 end
				 end  
				 set @val1 = @ayuda   
				 set @cont = 1    
				------
			SET @val2 = ''
    END
    ELSE
    BEGIN
        SET @lstDato = Substring( @val2 , 1  , @valespacio-1) 
        set @ayuda = @val1  
        while(len(@val1) >0) 
        begin			
			SET @valesp = CHARINDEX(@space, @val1 )
			IF ( @valesp=0 )
			 BEGIN 
				SET @adicional = @val1
				--------------------- VERIFICAR
				if(@lstDato = @adicional)
				 begin
					set @resul += convert(varchar(1),@cont)
					set @cont = @cont +1
					--print @resul
				 end	
				else 	
				 begin
					set @cont = @cont +1
				 end	
				---------------------
				SET @val1 = ''
			 END
			ELSE
			 begin
				SET @adicional = Substring( @val1 , 1  , @valesp-1) 
				if(@lstDato = @adicional)
				 begin
					set @resul += convert(varchar(1),@cont)
					set @cont = @cont +1
					--print @resul
				 end	
				else 	
				 begin
					set @cont = @cont +1
				 end	
				SET @val1 = Substring( @val1 , @valesp + 1 , LEN(@val1))
			 end
        end  
        set @val1 = @ayuda   
        set @cont = 1    
        SET @val2 = Substring( @val2 , @valespacio + 2 , LEN(@val2))
    END
	end
	------------------------------
	return @resul
end

GO
