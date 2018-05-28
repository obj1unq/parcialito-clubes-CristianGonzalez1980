//parcialito28
class Club {

	var property perfil
	const property actividades = #{}
	var property socios = #{}
	var property gastoMensual

	method sancionar() {
		if (self.sePuedeSancionar()) {
			self.actividades().foreach({ actividad => actividad.sancionar()})
		}
	}

	method sePuedeSancionar() {
		return (self.cantidadDeSocios() >= 500)
	}

	method cantidadDeSocios() {
		return (self.socios().size())
	}

	method evaluacion() {
		return (self.evaluacionBruta() / self.cantidadDeSocios())
	}

	method evaluacionBruta() {
		return (self.evaluacionesSegunPerfil(self.perfil()))
	}

	method evaluacionesSegunPerfil(perfilDelClub) {
		if (self.perfil() == "tradicional") {
			return (self.evaluacionesPerfilTradicional())
		} else {
			if (self.perfil() == "profesional") {
				return (self.evaluacionesPerfilProfesional())
			} else {
				return (self.evaluacionesPerfilComunitario())
			}
		}
	}

	method evaluacionDeActividades() {
		return (self.actividades().map({ actividad => actividad.evaluacion() }).sum())
	}

	method evaluacionesPerfilTradicional() {
		return (self.evaluacionDeActividades() - self.gastoMensual())
	}

	method evaluacionesPerfilComunitario() {
		return (self.evaluacionDeActividades())
	}

	method evaluacionesPerfilProfesional() {
		return (self.evaluacionDeActividades() * 2 - self.gastoMensual() * 5)
	}

	method sociosDestacados() {
		return (self.actividades().map({ actividad => actividad.destacado() }))
	}

	method sociosEstrellas() {
		return (self.socios().filter({ socio => socio.esEstrella() }))
	}

	method sociosDestacadosEstrellas() {
		return (self.sociosDestacados().intersection(self.sociosEstrellas()))
	}

	method esPrestigioso() {
		return(self.actividades().any({actividad => actividad.dePrestigio()}))
	}

}

class Actividad {

	method evaluacion()

	method participantes()

	method sancionar()

	method destacado()

	method dePrestigio()

}

class ActividadSocial inherits Actividad {

	var socioOrganizador
	var property sociosParticipantes = #{}
	var suspendida
	var valor

	override method participantes() {
		return sociosParticipantes
	}

	override method sancionar() {
		suspendida = true
	}

	method reanudarActividad() {
		suspendida = false
	}

	method estaSuspendida() {
		return (suspendida)
	}

	override method evaluacion() {
		if (!self.estaSuspendida()) {
			return (valor)
		} else {
			return (0)
		}
	}

	override method destacado() {
		return (socioOrganizador)
	}

	override method dePrestigio() {
		return ((self.sociosParticipantes().filter({socio => socio.esEstrella()})).size()>=5)
	}

}

class Equipo inherits Actividad {

	var capitan
	const property plantel = #{}
	var cantidadDeSanciones
	var campeonatosObtenidos

	override method participantes() {
		return plantel
	}

	override method sancionar() {
		cantidadDeSanciones += 1
	}

	method cantidadDeSanciones() {
		return (cantidadDeSanciones)
	}

	override method evaluacion() {
		return (campeonatosObtenidos * 5 + plantel.size() * 2 + self.puntosSiEsEstrella(capitan) - self.puntosPorCantidadDeSanciones())
	}

	method puntosSiEsEstrella(socio) {
		if (socio.esEstrella()) {
			return 5
		} else return 0
	}

	method puntosPorCantidadDeSanciones() {
		return (cantidadDeSanciones * 20)
	}

	override method destacado() {
		return (capitan)
	}

	method esExperimentado() {
		return (self.plantel().all({ jugador => jugador.partidosJugados() >= 10 }))
	}

	override method dePrestigio() {
		return (self.esExperimentado())
	}

}

class EquipoDeFutbol inherits Equipo {

	override method evaluacion() {
		return (super() + self.puntosPorEstrellas(self.plantel()))
	}

	method puntosPorEstrellas(plantel) {
		return (plantel.map({ jugador => self.puntosSiEsEstrella(jugador) }).sum())
	}

	override method puntosPorCantidadDeSanciones() {
		return (cantidadDeSanciones * 30)
	}

}

class Socio {

	const property numero
	var property aniosEnLaInstitucion
	var property club

	method esEstrella() {
		return (self.aniosEnLaInstitucion() > 20)
	}

}

class Jugador inherits Socio {

	var valorEstrella = profesional.valorBase()
	var paseValor
	var property partidosJugados

	override method esEstrella() {
		return (self.partidosJugados() > 50 || self.condicionPerfilClub())
	}

	method condicionPerfilClub() {
		return (self.condicionPerfilProfesional() || self.condicionPerfilComunitario(self) || self.condicionPerfilTradicional(self))
	}

	method condicionPerfilProfesional() {
		return (self.club().perfil() == "profesional" && self.superaValorBase())
	}

	method condicionPerfilComunitario(socio) {
		return (self.club().perfil() == "comunitario" && self.actividadesMayoresA(3, socio))
	}

	method superaValorBase() {
		return (paseValor > valorEstrella)
	}

	method condicionPerfilTradicional(socio) {
		return (self.club().perfil() == "tradicional" && (self.superaValorBase() || self.actividadesMayoresA(3, socio)))
	}

	method actividadesMayoresA(numero, socio) {
		return (self.participacionEnActividades(socio).size() > numero)
	}

	method participacionEnActividades(socio) {
		return (self.club().actividades().filter({ actividad => actividad.participantes().find({ participante => participante.numero() == socio.numero()}) }))
	}

}

object profesional {

	method valorBase() {
		return 0
	}

}

