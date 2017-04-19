SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Seg_ControlGrupos_Fcn]
@Nodo1 nvarchar(10),
@Nodo2 nvarchar(10),
@Opc int,
	-- Opcion 1 = Asginar como hijo
	-- Opcion 2 = Asginar como hermano
	-- Opcion 3 = Desplazar nodo
@msj varchar(100) output
as




if(@Opc = 1) -- ASIGNAR COMO HIJO
begin
	/**********************************************************************/
	/*EL NODO SELECCINADO PASA COMO HIJO DEL NODO ANTERIOR*/
	/**********************************************************************/
	
	Declare @Nivel nvarchar(10)
	Set @Nivel = ''
	
	--OBTENIENDO EL CODIGO NUEVO DEL HIJO
	Set @Nivel = (Select isnull(@Nodo1+right('00'+ltrim(str(convert(int,right(Max(Nivel),2))+1)),2),@Nodo1+'01')
		      From ControlGrupos 
		      Where Nivel like @Nodo1+'%' and len(Nivel)=len(@Nodo1)+2)
	
	Print @Nivel
	
	--ACTUALIZANDO CODIGO PADRE e HIJOS
	update ControlGrupos set
		Nivel = @Nivel+right(Nivel,len(Nivel)-len(@Nodo2))
	Where Nivel like @Nodo2+'%'
	
	/**********************************************************************/
end
else if(@Opc = 2) -- ASIGNAR COMO HERMANO
begin
	/**********************************************************************/
	/*EL NODO SELECCINADO PASA COMO HERMANO DEL NODO ANTERIOR*/
	/**********************************************************************/
	
	--ORGANIZANDO LOS CODIGOS EN FORMA ASCENDENTE
	
	update ControlGrupos Set
		Nivel = left(@Nodo1,len(@Nodo1)-2)+right('00'+ltrim(str(convert(int,right(left(Nivel,len(@Nodo1)),2))+1)),2)+right(Nivel,len(Nivel)-len(@Nodo1))
	Where Nivel >= left(@Nodo1,len(@Nodo1)-2)+right('00'+ltrim(str(convert(int,right(@Nodo1,2))+1)),2)
	
	--ACTUALIZANDO EL NODO SELECCIONADO
	Declare @Cod nvarchar(10)
	Set @Cod = ''
	
	Set @Cod = (select left(@Nodo1,len(@Nodo1)-2)+right('00'+ltrim(str(convert(int,right(Max(@Nodo1),2))+1)),2) 
	            from ControlGrupos where Nivel like left(@Nodo1,len(@Nodo1)-2)+'%' and len(Nivel) = len(@Nodo1))
	
	print @Cod
	
	--ACTUALIZANDO EL NODO SELECCIONADO
	update ControlGrupos Set
		Nivel = @Cod+right(Nivel,len(Nivel)-len(@Nodo2))
	Where Nivel like @Nodo2+'%'
	
	/**********************************************************************/
end
else if(@Opc = 3)-- SUBIR O BAJAR NODO
begin

	/**********************************************************************/
	/*EL NODO SELECCINADO SUBE o BAJA*/
	/**********************************************************************/
	
	Update  ControlGrupos Set Nivel='c'+@Nodo2+right(Nivel,len(Nivel)-len(@Nodo1)) where Nivel like @Nodo1+'%'
	Update  ControlGrupos Set Nivel=@Nodo1+right(Nivel,len(Nivel)-len(@Nodo2)) where Nivel like @Nodo2+'%'
	Update  ControlGrupos Set Nivel=right(Nivel,len(Nivel)-1) where Nivel like 'c'+@Nodo2+'%'
	
	/**********************************************************************/
end

-- Leyenda --
-------------

-- DI 30/09/2009 : Creacion del procedimiento almacenado
GO
